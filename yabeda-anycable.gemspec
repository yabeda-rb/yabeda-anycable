# frozen_string_literal: true

require_relative "lib/yabeda/anycable/version"

Gem::Specification.new do |spec|
  spec.name          = "yabeda-anycable"
  spec.version       = Yabeda::AnyCable::VERSION
  spec.authors       = ["Andrey Novikov"]
  spec.email         = ["envek@envek.name"]

  spec.summary       = "Collect performance metrics for AnyCable RPC server"
  spec.description   = <<~DESC
    Yabeda plugin for easy collection of most important AnyCable RPC metrics: \
    number and duration of executed commands, etc…
  DESC
  spec.homepage      = "https://github.com/yabeda-rb/yabeda-anycable"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yabeda-rb/yabeda-anycable"
  spec.metadata["changelog_uri"] = "https://github.com/yabeda-rb/yabeda-anycable/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "anycable-core", "~> 1.1"
  spec.add_dependency "yabeda",        "~> 0.10"
end
