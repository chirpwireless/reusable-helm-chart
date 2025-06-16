{{/*
Expand the name of the chart.
*/}}
{{- define "reusable-helm-chart.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "reusable-helm-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
{{- else }}
{{- $name := default .Release.Name .Values.nameOverride }}
{{- .Release.Name | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "reusable-helm-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "reusable-helm-chart.labels" -}}
helm.sh/chart: {{ include "reusable-helm-chart.chart" . }}
{{ include "reusable-helm-chart.selectorLabels" . }}
app.kubernetes.io/type: application
app.kubernetes.io/chart: {{ .Chart.Name | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
app.kubernetes.io/release: {{ .Release.Name | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
app.kubernetes.io/namespace: {{ .Release.Namespace }}
app.kubernetes.io/version: {{ .Chart.AppVersion | replace "+" "_" | trunc 63 | trimSuffix "-" | trimSuffix "."  | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "reusable-helm-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "reusable-helm-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name | trunc 63 | trimSuffix "-" | trimSuffix "."  }}
{{- end -}}

{{/*
Common helm test labels
*/}}
{{- define "reusable-helm-chart.helmtest.labels" -}}
{{- $top := index . 0 }}
{{- $context := index . 1 }}
helm.sh/chart: {{ include "reusable-helm-chart.chart" $top }}
{{ include "reusable-helm-chart.selectorLabels" $top }}
app.kubernetes.io/type: "helm-test"
app.kubernetes.io/version: {{ $context.image.tag | replace "+" "_" | trunc 63 | trimSuffix "-" | trimSuffix "." | quote }}
app.kubernetes.io/managed-by: {{ $top.Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "reusable-helm-chart.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create }}
{{- default (include "reusable-helm-chart.fullname" .) .Values.global.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.global.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the rbac to use
*/}}
{{- define "reusable-helm-chart.rbacName" -}}
{{- default (include "reusable-helm-chart.fullname" .) .Values.global.rbac.name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "reusable-helm-chart.affinity" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/release
              operator: In
              values:
                - "{{ .Release.Name }}"
            - key: app.kubernetes.io/namespace
              operator: In
              values:
                - "{{ .Release.Namespace }}"
        topologyKey: topology.kubernetes.io/zone
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
          - key: app.kubernetes.io/release
            operator: In
            values:
              - "{{ .Release.Name }}"
          - key: app.kubernetes.io/namespace
            operator: In
            values:
              - "{{ .Release.Namespace }}"
      topologyKey: "kubernetes.io/hostname"
{{- end -}}

{{/*
Create extra environments
*/}}
{{- define "application.extraEnv" -}}
{{- range .Values.extraEnv }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end }}

{{/*
Create custom initContainers for application and cronjob
*/}}
{{- define "application.initContainers" -}}
{{- $top := index . 0 }}
{{- $context := index . 1 }}
{{- range $context.initContainers }}
- name: {{ .name }}
  image: "{{ .image.repository }}:{{ .image.tag }}"
  imagePullPolicy: {{ .image.pullPolicy }}
  env:
    {{- range $context.extraEnv }}
    - name: {{ .name }}
      value: {{ .value | quote }}
    {{- end }}
    {{- range .extraEnv }}
    - name: {{ .name }}
      value: {{ .value | quote }}
    {{- end }}
  envFrom:
    {{- with $context.extraEnvFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- with .extraEnvFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  volumeMounts:
    {{- range $context.extraMemoryMount }}
    {{- if .mountPath }}
    - name: memory-{{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- range $context.extraVolumeMounts }}
    {{- if .mountPath }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- range $context.extraConfigMap }}
    {{- if .mountPath }}
    - name: configmap-{{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
  {{- with .command }}
  command: {{ . }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Create custom sidecars for application and cronjob
*/}}
{{- define "application.sidecars" -}}
{{- $top := index . 0 }}
{{- $context := index . 1 }}
{{- range $context.sidecars }}
- name: {{ .name }}
  image: "{{ .image.repository }}:{{ .image.tag }}"
  imagePullPolicy: {{ .image.pullPolicy }}
  env:
    {{- range $context.extraEnv }}
    - name: {{ .name }}
      value: {{ .value | quote }}
    {{- end }}
    {{- range .extraEnv }}
    - name: {{ .name }}
      value: {{ .value | quote }}
    {{- end }}
  envFrom:
    {{- with $context.extraEnvFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- with .extraEnvFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  volumeMounts:
    {{- range $context.extraMemoryMount }}
    {{- if .mountPath }}
    - name: memory-{{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- range $context.extraVolumeMounts }}
    {{- if .mountPath }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- range $context.extraConfigMap }}
    {{- if .mountPath }}
    - name: configmap-{{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- range .extraVolumeMounts }}
    {{- if .mountPath }}
    - name: {{ .name }}
      mountPath: {{ .mountPath }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
    {{- end }}
    {{- end }}
  {{- with .command }}
  command: {{ . }}
  {{- end }}
{{- end -}}
{{- end -}}