require 'spec_helper'

describe LightService::Organizer do
  class AnAction; end

  class AnOrganizer
    include LightService::Organizer

    def self.some_method(user)
      with(user: user).reduce [AnAction]
    end

    def self.some_method_with(user)
      context = LightService::Context.make(user: user)
      with(context).reduce [AnAction]
    end
  end

  let(:context) { ::LightService::Context.make(user: user) }
  let(:user) { double(:user) }

  context "when #with is called with hash" do
    before do
      AnAction.should_receive(:execute) \
              .with(context) \
              .and_return context
    end

    it "creates a Context" do
      result = AnOrganizer.some_method(user)
      expect(result).to eq(context)
    end
  end
end
