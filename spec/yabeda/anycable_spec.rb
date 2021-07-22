# frozen_string_literal: true

RSpec.describe Yabeda::AnyCable do
  it "has a version number" do
    expect(Yabeda::AnyCable::VERSION).not_to be nil
  end

  it "injects middleware to AnyCable RPC server" do
    expect(AnyCable.middleware.to_a).to include(kind_of(Yabeda::AnyCable::Middleware))
  end
end
