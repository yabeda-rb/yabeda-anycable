# frozen_string_literal: true

RSpec.describe Yabeda::AnyCable::Middleware do
  subject(:call_middleware) { middleware.call(method, request, nil, &block) }

  let(:method) { :connect }
  let(:middleware) { described_class.new }
  let(:block) { proc { response } }
  let(:request) { AnyCable::ConnectionRequest.new(env: {}) }
  let(:response) { AnyCable::ConnectionResponse.new(status: AnyCable::Status::SUCCESS) }
  let(:adapter) { Yabeda.adapters[:test] }

  it "yields and returns response from handler" do
    expect(subject).to eq(response)
  end

  context "with connection request" do
    it "increments counter" do
      expect { call_middleware }.to \
        increment_yabeda_counter(Yabeda.anycable.rpc_call_count)
        .with_tags(method: "connect", command: "", status: "SUCCESS")
    end

    it "measures block runtime" do
      expect do
        middleware.call(method, request) do
          sleep(0.01)
          response
        end
      end.to \
        measure_yabeda_histogram(Yabeda.anycable.rpc_call_runtime)
        .with(be_between(0.005, 0.05))
        .with_tags(method: "connect", command: "", status: "SUCCESS")
    end
  end

  context "with command request" do
    let(:method) { :command }
    let(:request) { AnyCable::CommandMessage.new(command: "subscribe", identifier: "whatever") }

    it "increments counter with command label set" do
      expect { call_middleware }.to \
        increment_yabeda_counter(Yabeda.anycable.rpc_call_count)
        .with_tags(method: "command", command: "subscribe", status: "SUCCESS")
    end

    it "measures block runtime with command label set" do
      expect do
        middleware.call(method, request) do
          sleep(0.01)
          response
        end
      end.to \
        measure_yabeda_histogram(Yabeda.anycable.rpc_call_runtime)
        .with(be_between(0.005, 0.05))
        .with_tags(method: "command", command: "subscribe", status: "SUCCESS")
    end
  end
end
