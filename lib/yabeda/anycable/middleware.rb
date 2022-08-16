# frozen_string_literal: true

require "anycable/middleware"

module Yabeda
  module AnyCable
    # Instrumentation middleware that wraps every RPC command execution
    class Middleware < ::AnyCable::Middleware
      def call(rpc_method_name, request, _metadata = nil)
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        (response = yield)
      ensure
        elapsed = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(4)
        labels = { method: rpc_method_name.to_s, status: response.respond_to?(:status) ? response.status.to_s : "ERROR" }
        labels[:command] = request.respond_to?(:command) ? request.command : ""
        ::Yabeda.anycable.rpc_call_count.increment(labels)
        ::Yabeda.anycable.rpc_call_runtime.measure(labels, elapsed)
      end
    end
  end
end
