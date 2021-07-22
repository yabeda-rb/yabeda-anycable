# frozen_string_literal: true

require "yabeda/anycable"
require "anycable/cli"

require_relative "support/yabeda_test_adapter"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Kernel.srand config.seed
  # config.order = :random

  config.before(:all) do
    AnyCable::CLI.new.send(:configure_server!)
    Yabeda.register_adapter(:test, YabedaTestAdapter.new)
    Yabeda.configure! unless Yabeda.already_configured?
  end

  config.after(:all) do
  end
end
