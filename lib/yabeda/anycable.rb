# frozen_string_literal: true

require "yabeda"
require "anycable"

require_relative "anycable/middleware"
require_relative "anycable/version"

module Yabeda
  # Yabeda plugin for instrumenting AnyCable RPC server
  module AnyCable
    class Error < StandardError; end

    RUNTIME_HISTOGRAM_BUCKETS = [
      0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, 30, 60,
    ].freeze

    ::AnyCable.configure_server do
      ::Yabeda.configure do
        ::AnyCable.middleware.use(Middleware)

        group :anycable

        counter :rpc_call_count, tags: %i[method command status], comment: "RPC calls count"

        histogram :rpc_call_runtime,
                  comment: "RPC call execution time",
                  unit: :seconds, per: :call,
                  tags: %i[method command status],
                  buckets: RUNTIME_HISTOGRAM_BUCKETS
      end
    end
  end
end
