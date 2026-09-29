#!/usr/bin/env bash
set -euo pipefail

chart=${1:-chart}
np=templates/networkpolicy.yaml

fail() { echo "NetworkPolicy assertion failed: $*" >&2; exit 1; }

count_kind() { grep -c '^kind: NetworkPolicy' || true; }

default_out=$(helm template "$chart")
[ "$(count_kind <<<"$default_out")" -eq 0 ] || fail "expected 0 NetworkPolicy objects with default values"

rendered() { helm template "$chart" -f "$chart/ci/$1" --show-only "$np"; }

selector_labels() {
  awk -v key="$1" '
    $0 ~ "^  " key ":" { in_key = 1; next }
    in_key && /^    matchLabels:/ { in_labels = 1; next }
    in_labels && /^      [^ ]/ { sub(/^ +/, ""); print; next }
    in_labels { exit }
  '
}

full=$(rendered networkpolicy-values.yaml)
[ "$(count_kind <<<"$full")" -eq 1 ] || fail "expected 1 NetworkPolicy object with networkPolicy.enabled=true"

policy_types=$(awk '/^  policyTypes:/ {f=1; next} f && /^    - / {print $2; next} f {exit}' <<<"$full")
[ "$policy_types" = "Ingress" ] || fail "policyTypes must be exactly [Ingress], got: $policy_types"

rules=$(awk '/^  ingress:/ {f=1; next} f && /^    - from:/ {n++} END {print n+0}' <<<"$full")
[ "$rules" -eq 3 ] || fail "expected 3 ingress rules from the fixture, got $rules"

policy_selector=$(selector_labels podSelector <<<"$full")
deployment_selector=$(helm template "$chart" --show-only templates/deployment.yaml | selector_labels selector)
[ -n "$policy_selector" ] || fail "podSelector.matchLabels is empty"
[ "$policy_selector" = "$deployment_selector" ] || fail "podSelector does not match the Deployment selector"

denyall=$(rendered networkpolicy-denyall-values.yaml)
grep -Eq '^  ingress:$' <<<"$denyall" || fail "deny-all render lost the ingress key"
[ "$(awk '/^  ingress:/ {f=1; next} f {print}' <<<"$denyall" | tr -d ' \n')" = "[]" ] || fail "empty ingress must render as []"
