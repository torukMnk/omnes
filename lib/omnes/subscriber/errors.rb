# frozen_string_literal: true

require "omnes/errors"

module Omnes
  module Subscriber
    # Raised when calling {Omnes::Subscriber#subscribe_to} multiple times for
    # the same instance/bus
    class MultipleSubscriberSubscriptionAttemptError < Omnes::Error
      # @api private
      def initialize
        super(default_message)
      end

      private

      def default_message
        <<~MSG
          Omnes::Subscriber#subscribe_to method can only be called once for a
          given instance on a given bus
        MSG
      end
    end
  end
end
