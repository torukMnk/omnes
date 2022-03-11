# frozen_string_literal: true

require "spec_helper"
require "omnes/subscription"

RSpec.describe Omnes::Subscription do
  let(:true_matcher) { ->(_candidate) { true } }
  let(:false_matcher) { ->(_candidate) { false } }

  describe "SINGLE_EVENT_MATCHER" do
    it "returns true when candidate name matches subscribed" do
      event = Struct.new(:name).new(:foo)

      expect(
        described_class::SINGLE_EVENT_MATCHER.(:foo, event)
      ).to be(true)
    end

    it "returns false when published and candidate don't match" do
      event = Struct.new(:name).new(:foo)

      expect(
        described_class::SINGLE_EVENT_MATCHER.(:bar, event)
      ).to be(false)
    end
  end

  describe "ALL_EVENTS_MATCHER" do
    it "returns true whichever the candidate" do
      expect(
        described_class::ALL_EVENTS_MATCHER.(:foo)
      ).to be(true)
    end
  end

  describe "#call" do
    it "returns an execution instance" do
      subscription = described_class.new(matcher: true_matcher, callback: proc {})

      expect(subscription.(:event)).to be_a(Omnes::Execution)
    end

    it "binds the event and sets execution's result" do
      subscription = described_class.new(matcher: true_matcher, callback: ->(event) { event[:foo] })

      execution = subscription.(foo: :bar)

      expect(execution.result).to eq(:bar)
    end

    it "sets itself as the execution subscription" do
      subscription = described_class.new(matcher: true_matcher, callback: proc { "foo" })

      execution = subscription.(:event)

      expect(execution.subscription).to be(subscription)
    end

    it "sets the execution's benchmark" do
      subscription = described_class.new(matcher: true_matcher, callback: proc { "foo" })

      execution = subscription.(:event)

      expect(execution.benchmark).to be_a(Benchmark::Tms)
    end
  end

  describe "#matches?" do
    it "return true when matcher returns true for given candidate" do
      subscription = described_class.new(matcher: true_matcher, callback: -> {})

      expect(subscription.matches?(:foo)).to be(true)
    end

    it "return false when matcher returns false for given candidate" do
      subscription = described_class.new(matcher: false_matcher, callback: -> {})

      expect(subscription.matches?(:bar)).to be(false)
    end
  end

  describe "#subscriptions" do
    it "returns a list containing only itself" do
      subscription = described_class.new(matcher: true_matcher, callback: -> {})

      expect(subscription.subscriptions).to eq([subscription])
    end
  end
end
