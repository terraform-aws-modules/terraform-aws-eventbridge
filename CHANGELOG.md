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
