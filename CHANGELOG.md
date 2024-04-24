# Changelog

All notable changes to this project will be documented in this file.

## [3.3.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.3.0...v3.3.1) (2024-04-24)


### Bug Fixes

* Default to null when state argument is not set ([#122](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/122)) ([ed4b013](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ed4b013a512c40277d7b707c03bf23e235a058ec))

## [3.3.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.2.4...v3.3.0) (2024-04-23)


### Features

* Replace deprecated is_enabled with state in EventBridge rules ([#119](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/119)) ([920138a](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/920138a97e88e1c89f2439c737e17060a23f64de))

## [3.2.4](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.2.3...v3.2.4) (2024-04-05)


### Bug Fixes

* Made input_paths in input_transformer optional ([#116](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/116)) ([1ce4aca](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/1ce4acaeee77f8043395cb81d598d97330404ebd))

## [3.2.3](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.2.2...v3.2.3) (2024-03-07)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#111](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/111)) ([a75692c](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/a75692c08ee7ae4f323c429ee75260660cd022c7))

### [3.2.2](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.2.1...v3.2.2) (2024-02-05)


### Bug Fixes

* Allow API destinations to reuse connections ([#108](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/108)) ([78ac5d7](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/78ac5d7711b2715c93f69632a38c6e508e8f7cdd))

### [3.2.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.2.0...v3.2.1) (2024-02-02)


### Bug Fixes

* Fixed newline handling in input_template ([#107](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/107)) ([35a2acb](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/35a2acb4d1bc32b9c746df133d7c75b68b2a76f7))

## [3.2.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.1.0...v3.2.0) (2024-01-12)


### Features

* Add input_template in target_parameters for pipes ([#102](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/102)) ([9406fcb](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/9406fcbec0234c31eb602fc9e95dca99d61cac98))

## [3.1.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.0.1...v3.1.0) (2024-01-12)


### Features

* Add `state` to `aws_cloudwatch_event_rule` ([#100](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/100)) ([963753f](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/963753f118f93b470efdf72e4dc0e620fbeac58a))

### [3.0.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v3.0.0...v3.0.1) (2024-01-12)


### Bug Fixes

* Event bus data source count conditional ([#101](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/101)) ([ebe5963](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ebe5963b58d64625fc3c29e86e8a3454e0b9b636))

## [3.0.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v2.3.0...v3.0.0) (2023-10-02)


### ⚠ BREAKING CHANGES

* Upgraded AWS provider to v5 (required for Pipes) (#94)

### Features

* Add support for EventBridge Pipes ([#92](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/92)) ([ff131eb](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ff131eb904358d7956d3941bae691ca710daa838))
* Upgraded AWS provider to v5 (required for Pipes) ([#94](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/94)) ([ba4d055](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ba4d055d0aabb16e356934c594ad26cc2057f058))

## [2.4.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v2.3.0...v2.4.0) (2023-10-01)


### Features

* Add support for EventBridge Pipes ([#92](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/92)) ([ff131eb](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ff131eb904358d7956d3941bae691ca710daa838))

## [2.3.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v2.2.0...v2.3.0) (2023-06-17)


### Features

* Support for Eventbridge Scheduler Schedules ([#83](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/83)) ([e3c4ffe](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/e3c4ffedb73a7d0fcbcafad7877c5268c147af48))

## [2.2.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v2.1.0...v2.2.0) (2023-06-15)


### Features

* Add attach_sns_policy ([#89](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/89)) ([6e09aa1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/6e09aa190aef287a1e917b430d275d9ff5f31bde))

## [2.1.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v2.0.0...v2.1.0) (2023-04-28)


### Features

* Add support for setting the condition field in Event Bus permissions ([#84](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/84)) ([49f1dff](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/49f1dffe2a85f7a9e1d87a55c1d6f806bbea7191))

## [2.0.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.17.3...v2.0.0) (2023-04-28)


### ⚠ BREAKING CHANGES

* Bump Terraform version to 1.0 and updated `ecs_target` arguments (#85)

### Features

* Bump Terraform version to 1.0 and updated `ecs_target` arguments ([#85](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/85)) ([04a3249](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/04a3249041c28c24d8ea01ee11619e348c553958))

### [1.17.3](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.17.2...v1.17.3) (2023-03-10)


### Bug Fixes

* Enable adding event_source_name to an Event Bus to enable receiving events from an SaaS partner ([#82](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/82)) ([f92a78c](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/f92a78c6ffa87573cd16d32449738a7df24d2a62))

### [1.17.2](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.17.1...v1.17.2) (2023-01-18)


### Bug Fixes

* Wrong value of api destination output ([#79](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/79)) ([03ef4ff](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/03ef4ff5927259b53c4b10c9d90d39db78e80196))

### [1.17.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.17.0...v1.17.1) (2023-01-06)


### Bug Fixes

* Fixed misleading descriptions of IAM role (not Lambda) ([#76](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/76)) ([aa92195](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/aa92195cd77bf2152c188ab610c106fe47386b96))
* Use a version for  to avoid GitHub API rate limiting on CI workflows ([#75](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/75)) ([e9a7813](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/e9a7813f9f693590f73a0c89f7769acce61388b1))

## [1.17.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.16.0...v1.17.0) (2022-10-28)


### Features

* Upgraded AWS provider version to 4.7 ([#66](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/66)) ([7690287](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/76902879b4b18f4de0cacf8ad0e4a0b05239fd23))

## [1.16.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.15.1...v1.16.0) (2022-10-28)


### Features

* Add schema discoverer ([#64](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/64)) ([0099c43](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/0099c43dc03e26d0c21ed606e43d57e56284c7a9))

### [1.15.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.15.0...v1.15.1) (2022-09-21)


### Bug Fixes

* Fixed inappropriate values for subnets and security_groups in example ([#63](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/63)) ([fd7a25b](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/fd7a25b4c995510bff3b69f8a942c50f6fe06a7d))

## [1.15.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.14.3...v1.15.0) (2022-09-09)


### Features

* Added Name tag for IAM policies and roles ([#62](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/62)) ([8ca8835](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/8ca88350a4de0d5fff5811d1e802f02b48f5b032))

### [1.14.3](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.14.2...v1.14.3) (2022-09-08)


### Bug Fixes

* Problems found when importing resources previously already created ([#61](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/61)) ([015122e](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/015122e9a7204ef35b7812781e076d861d5945b5))

### [1.14.2](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.14.1...v1.14.2) (2022-07-28)


### Bug Fixes

* Make it optional to append postfix to the name, connection, or API destination  ([#58](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/58)) ([980b910](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/980b9108aa34c9354a2e847de03c95b3a012b3d0))

### [1.14.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.14.0...v1.14.1) (2022-06-23)


### Bug Fixes

* Enable run_command_targets support for target ([#54](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/54)) ([e153898](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/e1538986d9431dcb01795458ced24d7e28cae108))

## [1.14.0](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.4...v1.14.0) (2022-02-04)


### Features

* Added support for custom role_arn in targets ([#42](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/42)) ([45311f7](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/45311f7e4cbd2d1eda148add97fc0569d235d0b6))

### [1.13.4](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.3...v1.13.4) (2022-01-21)


### Bug Fixes

* Fixed incorrect tomap() ([#39](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/39)) ([05bceba](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/05bceba343470ab41272a2345ec45da86d1721f0))

## [1.13.3](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.2...v1.13.3) (2022-01-06)


### Bug Fixes

* Amend batch_target to be correct value ([#35](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/35)) ([babb4d6](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/babb4d6eb00574631935c1b6423dc9a6e562fc3e))

## [1.13.2](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.1...v1.13.2) (2021-12-07)


### Bug Fixes

* Fixed outputs when create=false ([#33](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/33)) ([3dcc882](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/3dcc882b5b0960c96b7ceca045e0690af919078e))

## [1.13.1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.0...v1.13.1) (2021-11-22)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#31](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/31)) ([ad31225](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/commit/ad31225cf7b980a26ec55ecedc853f3548d7af00))

<a name="v1.13.0"></a>
## [v1.13.0] - 2021-11-07

- feat: Added support for API destinations ([#27](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/27))


<a name="v1.12.0"></a>
## [v1.12.0] - 2021-10-26

- fix: Fixed function name from to_map to tomap ([#26](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/26))


<a name="v1.11.0"></a>
## [v1.11.0] - 2021-10-12

- feat: Add example for ECS + scheduled events ([#14](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/14))


<a name="v1.10.0"></a>
## [v1.10.0] - 2021-09-21

- fix: Amend ecs_target network_configuration to work when no ecs_target supplied ([#25](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/25))


<a name="v1.9.0"></a>
## [v1.9.0] - 2021-09-09

- fix: Add explicit to_map for empty object for aws_cloudwatch_event_target ([#24](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/24))


<a name="v1.8.0"></a>
## [v1.8.0] - 2021-08-18

- feat: Support for existing event buses ([#22](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/22))


<a name="v1.7.0"></a>
## [v1.7.0] - 2021-08-13

- fix: update sqs access policy ([#16](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/16))


<a name="v1.6.0"></a>
## [v1.6.0] - 2021-08-13

- fix: `create_rules = false` causes error ([#19](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/19))


<a name="v1.5.0"></a>
## [v1.5.0] - 2021-06-28

- fix: remove create_bus as a blocker for role_arn ([#13](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/13))


<a name="v1.4.0"></a>
## [v1.4.0] - 2021-06-07

- feat: support http_target argument ([#11](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/11))
- fix: Fix tomap call for terraform 0.15 ([#10](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/10))


<a name="v1.3.0"></a>
## [v1.3.0] - 2021-05-28

- fix: property lookup in ecs_target block ([#8](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/8))


<a name="v1.2.0"></a>
## [v1.2.0] - 2021-05-25

- chore: Remove check boxes that don't render properly in module doc ([#9](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/9))
- chore: Updated versions&comments in examples


<a name="v1.1.0"></a>
## [v1.1.0] - 2021-04-08

- feat: Simplified outputs (no this_) ([#6](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/6))


<a name="v1.0.0"></a>
## [v1.0.0] - 2021-04-08

- feat: Some refactoring and added ability to handle default bus ([#5](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/5))


<a name="v0.1.0"></a>
## [v0.1.0] - 2021-03-27

- docs: update module references ([#3](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/3))


<a name="v0.0.1"></a>
## v0.0.1 - 2021-03-22

- docs(readme): add terraform-docs ([#2](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/2))
- feat: first commit ([#1](https://github.com/terraform-aws-modules/terraform-aws-eventbridge/issues/1))
- first commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.13.0...HEAD
[v1.13.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.12.0...v1.13.0
[v1.12.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.11.0...v1.12.0
[v1.11.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.10.0...v1.11.0
[v1.10.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.9.0...v1.10.0
[v1.9.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.5.0...v1.6.0
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v0.1.0...v1.0.0
[v0.1.0]: https://github.com/terraform-aws-modules/terraform-aws-eventbridge/compare/v0.0.1...v0.1.0
