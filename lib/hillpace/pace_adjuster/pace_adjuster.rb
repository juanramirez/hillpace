require_relative '../pace'

module Hillpace
  module PaceAdjuster

    class PaceAdjuster
      # Initializes a PaceAdjuster object.
      # @param strategy [Proc] The adjust strategy that the pace adjuster will use.
      def initialize(strategy)
        @strategy = strategy
      end

      # Adjusts a reference pace depending on the incline.
      # @param pace [Pace] A reference pace,
      # @param incline [Number] An incline value.
      # @return [Pace]
      def adjust_pace(pace, incline)
        @strategy.call pace, incline
      end
    end
  end
end
