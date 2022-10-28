# Changelog

All notable changes to this project will be documented in this file.

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
