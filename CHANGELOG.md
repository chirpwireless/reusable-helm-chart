## [1.5.3](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.5.2...v1.5.3) (2025-07-14)


### Bug Fixes

* Update cronjob extra env variables ([cd5b5b4](https://github.com/chirpwireless/reusable-helm-chart/commit/cd5b5b40eb466259e599329c70de2f0c0f2b083a))

## [1.5.2](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.5.1...v1.5.2) (2025-07-14)


### Bug Fixes

* Update cronjob deployment ([26a12cf](https://github.com/chirpwireless/reusable-helm-chart/commit/26a12cf277741a434bed6e653513d92ff3e2c30c))

## [1.5.1](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.5.0...v1.5.1) (2025-06-26)


### Bug Fixes

* add dynamic volume binding to PVC template using lookup function ([35aece6](https://github.com/chirpwireless/reusable-helm-chart/commit/35aece67d604b2dc95b18fa39ce6052dca119b27))

# [1.5.0](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.5...v1.5.0) (2025-06-26)


### Features

* add keep annotation to PVC and remove volumeName field from schema ([1fffac2](https://github.com/chirpwireless/reusable-helm-chart/commit/1fffac280677ad4d07e60935430c93e08629ca37))

## [1.4.5](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.4...v1.4.5) (2025-06-26)


### Bug Fixes

* remove volumeName option from persistence configuration in Helm chart ([4f34c7d](https://github.com/chirpwireless/reusable-helm-chart/commit/4f34c7d643481f538a611de6d5ddad4849cf9c48))

## [1.4.4](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.3...v1.4.4) (2025-06-24)


### Bug Fixes

* add external secrets support for database migrations ([7573ccc](https://github.com/chirpwireless/reusable-helm-chart/commit/7573ccc9843cc193c219c428b994c4f0e24d6cca))

## [1.4.3](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.2...v1.4.3) (2025-06-19)


### Bug Fixes

* add proper indentation to command blocks in Helm templates ([0554ee4](https://github.com/chirpwireless/reusable-helm-chart/commit/0554ee46d6b2595ab9f19ddca13ef4227993b550))

## [1.4.2](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.1...v1.4.2) (2025-06-19)


### Bug Fixes

* update command field defaults from empty string array to empty array ([748ce9d](https://github.com/chirpwireless/reusable-helm-chart/commit/748ce9df0aa28e60edfddb388aeaff0116ea7548))
* update command fields to use array type instead of string in Helm chart ([570d4c1](https://github.com/chirpwireless/reusable-helm-chart/commit/570d4c148d859316208219e78b9a7ffb45242d23))

## [1.4.1](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.4.0...v1.4.1) (2025-06-19)


### Bug Fixes

* add securityContext support for application containers in helm chart ([4478c3f](https://github.com/chirpwireless/reusable-helm-chart/commit/4478c3fe2fc05144f838f2157fe6428650c4fc90))
* simplify PVC template by removing labels and updating name suffix ([94db447](https://github.com/chirpwireless/reusable-helm-chart/commit/94db4477b1142c49e7f8ba357e434b421b985306))

# [1.4.0](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.3.3...v1.4.0) (2025-06-19)


### Features

* add persistent volume claim support to helm chart ([d25fbf3](https://github.com/chirpwireless/reusable-helm-chart/commit/d25fbf33ae6adda5a37723438af879c8a3b2e975))

## [1.3.3](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.3.2...v1.3.3) (2025-06-16)


### Bug Fixes

* remove duplicate extraEnv loop and add resources configuration in container helper template ([bb79556](https://github.com/chirpwireless/reusable-helm-chart/commit/bb79556907333ea25be46effbe536c853172c0e7))

## [1.3.2](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.3.1...v1.3.2) (2025-06-16)


### Bug Fixes

* make value field optional in environment variables schema ([e593247](https://github.com/chirpwireless/reusable-helm-chart/commit/e593247682c6c6556070f1fb2e96f01fc9fb7b2e))
* move sidecar containers after main application container in deployment template ([b00e5f3](https://github.com/chirpwireless/reusable-helm-chart/commit/b00e5f33a2188a1f075815199d86a46f21f8cd06))

## [1.3.1](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.3.0...v1.3.1) (2025-06-16)


### Bug Fixes

* update git clone URL to use full repository path in helm chart release workflow ([40e51c8](https://github.com/chirpwireless/reusable-helm-chart/commit/40e51c855ea8c2de54e2fbf01c17f69e854641b4))
* update validation for schema ([300ab31](https://github.com/chirpwireless/reusable-helm-chart/commit/300ab31e81d7b28b963898ec34f1021f1bb5365c))

# [1.3.0](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.2.1...v1.3.0) (2025-06-16)


### Bug Fixes

* simplify environment variable handling in helm templates ([f1e85be](https://github.com/chirpwireless/reusable-helm-chart/commit/f1e85be75d3e476147cbcce0909219dbe5bf69de))


### Features

* add Liquibase database migration job with configurable settings ([0381dab](https://github.com/chirpwireless/reusable-helm-chart/commit/0381dab010ab45fd5d536cade7c978df2dadb27f))

## [1.2.1](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.2.0...v1.2.1) (2025-06-16)


### Bug Fixes

* correct variable scope in extraVolumeMounts range loop ([48e6fed](https://github.com/chirpwireless/reusable-helm-chart/commit/48e6fedb5a329131898617a508532f6fe70a44da))

# [1.2.0](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.1.0...v1.2.0) (2025-06-16)


### Bug Fixes

* update ingress and service port handling in NOTES.txt ([d50ef5b](https://github.com/chirpwireless/reusable-helm-chart/commit/d50ef5bdf334b2583f717b61caa6ef8dbfa667f6))


### Features

* add service port configuration and extra volume mounts to helm chart templates ([df95be3](https://github.com/chirpwireless/reusable-helm-chart/commit/df95be3e8abba79caa5a03a7318e8f0aac0bd8f4))
* convert ingress from single object to array to support multiple ingress definitions ([90322ae](https://github.com/chirpwireless/reusable-helm-chart/commit/90322ae69da4b41c825bad301121f8460b07c6c3))

# [1.1.0](https://github.com/chirpwireless/reusable-helm-chart/compare/v1.0.0...v1.1.0) (2025-06-13)


### Features

* add cluster-level RBAC templates for non-namespaced deployments ([9e5ed4c](https://github.com/chirpwireless/reusable-helm-chart/commit/9e5ed4c974385b039fd4dbacd28ab2115a7a3c33))
* add cronjob support and fix volume mount indentation in deployment template ([de8e9bd](https://github.com/chirpwireless/reusable-helm-chart/commit/de8e9bd88d3ee8c98a2e3cabb5800ddc7de4d217))
* add support for custom volume mounts in helm chart deployment ([9d66777](https://github.com/chirpwireless/reusable-helm-chart/commit/9d6677716bc4426ee81acde04bb422083388090a))

# 1.0.0 (2025-06-13)


### Bug Fixes

* add automount option for service account token in Helm chart schema ([2c13b3a](https://github.com/chirpwireless/reusable-helm-chart/commit/2c13b3a42d37591fa8b244857c2cea941556916f))
* correct charts directory path in helm chart release workflow ([5d67102](https://github.com/chirpwireless/reusable-helm-chart/commit/5d6710212fc38e5c64754772d1623c324cb00cf8))
* Small bugfixes to test release flow ([bc3d8c2](https://github.com/chirpwireless/reusable-helm-chart/commit/bc3d8c217d8622a68a28eaae3c2019fc89a63afd))
* update git remote handling to use separate authenticated origin for pushes ([f3effeb](https://github.com/chirpwireless/reusable-helm-chart/commit/f3effeb65f9b668f670b97141e297e42b676b226))
* update GitHub token reference to use default GITHUB_TOKEN ([b30b810](https://github.com/chirpwireless/reusable-helm-chart/commit/b30b810d352ed17a0964ec1c3efe3f3cc21b3120))
* update GitHub token to use GH_CI_PASSWORD secret for semantic release ([7214e61](https://github.com/chirpwireless/reusable-helm-chart/commit/7214e6142a8488285f8b2377996867e47c38c607))
* update helm chart paths from . to chart in validation workflow ([1839506](https://github.com/chirpwireless/reusable-helm-chart/commit/183950685b3e15515bbcd58a83bfd2126a217531))
* update helm chart paths from root to charts directory in CI workflow ([88ab3cb](https://github.com/chirpwireless/reusable-helm-chart/commit/88ab3cb54716308e7f29a60a07d44924e433b51a))
* update helm repository URLs to use reusable-helm-chart path ([64ab821](https://github.com/chirpwireless/reusable-helm-chart/commit/64ab821d8f1cbd41369f528f1e836f4d817bdec6))
* update semantic-release condition check to use string comparison ([7355dc4](https://github.com/chirpwireless/reusable-helm-chart/commit/7355dc4623b2db123f88c9d547dd4a8ee896338e))
* update serviceAccount template ([107a07a](https://github.com/chirpwireless/reusable-helm-chart/commit/107a07a524585ed31307e00c5bc0a3d00e746f10))


### Features

* add chart-releaser config file and integrate with release workflow ([b816089](https://github.com/chirpwireless/reusable-helm-chart/commit/b816089f4d109ffe58950ede70090e382299011e))
* add maintainer list ([ddb2fd5](https://github.com/chirpwireless/reusable-helm-chart/commit/ddb2fd5dd229b4288732559b4e3dd3936ac3e6fa))
* add support for sidecar containers in helm chart with configurable mounts and env vars ([70870f9](https://github.com/chirpwireless/reusable-helm-chart/commit/70870f97eb475cba0ced13b1f8eae5fc58f80979))
* enable service account creation by default ([12ee542](https://github.com/chirpwireless/reusable-helm-chart/commit/12ee5424dfd867a111b8801033ededad700e6673))
* remove scheduled label ([1347083](https://github.com/chirpwireless/reusable-helm-chart/commit/1347083a1dd689444f00006986654909e40554e1))
* trigger github-action ([18a2dd5](https://github.com/chirpwireless/reusable-helm-chart/commit/18a2dd5d55d34aa8d0a3f5827b33d62e6985dbfb))
