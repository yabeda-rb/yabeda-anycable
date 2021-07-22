# frozen_string_literal: true

RSpec.describe Yabeda::AnyCable::Middleware do
  subject(:call_middleware) { middleware.call(method, request, nil, &block) }

  let(:method) { :connect }
  let(:middleware) { described_class.new }
  let(:block) { proc { response } }
  let(:request) { AnyCable::ConnectionRequest.new(env: {}) }
  let(:response) { AnyCable::ConnectionResponse.new(status: AnyCable::Status::SUCCESS) }
  let(:adapter) { Yabeda.adapters[:test] }

  before do
    allow(Yabeda.adapters[:test]).to receive(:perform_histogram_measure!)
    allow(Yabeda.adapters[:test]).to receive(:perform_counter_increment!)
  end

  it "yields and returns response from handler" do
    is_expected.to eq(response)
  end

  context "with connection request" do
    it "increments counter" do
      call_middleware

      expect(Yabeda.adapters[:test]).to have_received(:perform_counter_increment!).with(
        Yabeda.anycable.rpc_call_count, { method: "connect", command: "", status: "SUCCESS" }, 1,
      )
    end

    it "measures block runtime" do
      middleware.call(method, request) do
        sleep(0.01)
        response
      end

      expect(Yabeda.adapters[:test]).to have_received(:perform_histogram_measure!).with(
        Yabeda.anycable.rpc_call_runtime,
        { method: "connect", command: "", status: "SUCCESS" },
        be_between(0.005, 0.05),
      )
    end
  end

  context "with command request" do
    let(:method) { :command }
    let(:request) { AnyCable::CommandMessage.new(command: "subscribe", identifier: "whatever") }

    it "increments counter with command label set" do
      call_middleware

      expect(Yabeda.adapters[:test]).to have_received(:perform_counter_increment!).with(
        Yabeda.anycable.rpc_call_count, { method: "command", command: "subscribe", status: "SUCCESS" }, 1,
      )
    end

    it "measures block runtime with command label set" do
      middleware.call(method, request) do
        sleep(0.01)
        response
      end

      expect(Yabeda.adapters[:test]).to have_received(:perform_histogram_measure!).with(
        Yabeda.anycable.rpc_call_runtime,
        { method: "command", command: "subscribe", status: "SUCCESS" },
        be_between(0.005, 0.05),
      )
    end
  end
end
