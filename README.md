# ![Yabeda::AnyCable](./yabeda-anycable-logo.png)

Built-in metrics for monitoring [AnyCable] RPC server out of the box! Part of the [Yabeda] suite.

See [AnyCable architecture](https://docs.anycable.io/architecture) on details on what AnyCable RPC server is. For monitoring of [AnyCable] websocket server you will need to use [monitoring capabilities](https://docs.anycable.io/anycable-go/instrumentation) built in [anycable-go] itself.

Get sample Grafana dashboard from [Grafana.com #14793](https://grafana.com/grafana/dashboards/14793) or from [`grafana-dashboard.json`](./grafana-dashboard.json) file.

## Installation

```ruby
gem 'yabeda-anycable'

# Then add monitoring system adapter, e.g.:
# gem 'yabeda-prometheus'

# If you're using Rails, don't forget to add plugin for it:
# gem 'yabeda-rails'
# But if not then you should run `Yabeda.configure!` manually when your app is ready.
```

And then execute:

    $ bundle

**And that is it!** AnyCable metrics are being collected!

Additionally, depending on your adapter, you may want to setup metrics export. E.g. for [yabeda-prometheus]:

```ruby
# config/initializers/anycable.rb or elsewhere
AnyCable.configure_server do
  Yabeda::Prometheus::Exporter.start_metrics_server!
end
```

## Metrics

- Counter of total number of RPC calls: `anycable_rpc_call_count` (segmented by `method`, `command`, and `status`)
- Histogram of RPC call duration: `anycable_rpc_call_runtime` (seconds per RPC call execution, segmented by `method`, `command`, and `status`)

`status` label may be one of `SUCCESS` (all is good), `FAILURE` (e.g. connection rejected), or `ERROR` (exception raised).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yabeda-rb/yabeda-anycable.

### Releasing

1. Bump version number in `lib/yabeda/anycable/version.rb`

   In case of pre-releases keep in mind [rubygems/rubygems#3086](https://github.com/rubygems/rubygems/issues/3086) and check version with command like `Gem::Version.new(Yabeda::AnyCable::VERSION).to_s`

2. Fill `CHANGELOG.md` with missing changes, add header with version and date.

3. Make a commit:

   ```sh
   git add lib/yabeda/anycable/version.rb CHANGELOG.md
   version=$(ruby -r ./lib/yabeda/anycable/version.rb -e "puts Gem::Version.new(Yabeda::AnyCable::VERSION)")
   git commit --message="${version}: " --edit
   ```

4. Create annotated tag:

   ```sh
   git tag v${version} --annotate --message="${version}: " --edit --sign
   ```

5. Fill version name into subject line and (optionally) some description (list of changes will be taken from changelog and appended automatically)

6. Push it:

   ```sh
   git push --follow-tags
   ```

7. GitHub Actions will create a new release, build and push gem into RubyGems! You're done!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[AnyCable]: https://anycable.io/ "Polyglot replacement for ActionCable server"
[anycable-go]: https://github.com/anycable/anycable-go "AnyCable WebSocket server written in Go"
[Yabeda]: https://github.com/yabeda-rb/yabeda "Extendable framework for collecting and exporting metrics from your Ruby application"
[yabeda-prometheus]: https://github.com/yabeda-rb/yabeda-prometheus "Adapter to expose metrics collected by Yabeda plugins to Prometheus via its offical Ruby client"
