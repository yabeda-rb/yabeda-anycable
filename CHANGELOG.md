## [0.1.2] - 2022-09-21

### Fixed

- Handle the case when application code raises an error on command. See [pull request №4](https://github.com/yabeda-rb/yabeda-anycable/pull/4)

## [0.1.1] - 2022-02-15

### Changed

- Add instrumentation middleware to AnyCable RPC only when Yabeda is actually used (configured). See [issue №2](https://github.com/yabeda-rb/yabeda-anycable/issues/2) 

## [0.1.0] - 2021-07-22

- Initial release with `anycable_rpc_call_count` and `anycable_rpc_call_runtime` metrics in an AnyCable middleware.
