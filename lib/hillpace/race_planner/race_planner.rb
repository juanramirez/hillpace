module Hillpace
  module RacePlanner
    class RacePlanner

      def initialize(strategy)
        @pace_adjuster = Hillpace::PaceAdjuster::PaceAdjuster.new strategy
      end

      def plan_race(route, split_distances, reference_pace)
        splitted_route = route.split split_distances
        segments = splitted_route.segments.clone.lazy
        race_plan = []

        accumulated_distance = 0
        segments.each do |segment|
          segment_plan = {
              :segment_start => accumulated_distance,
              :segment_end => accumulated_distance + segment.distance_meters,
              :incline => segment.incline,
              :adjusted_pace => @pace_adjuster.adjust_pace(reference_pace, segment.incline)
          }
          race_plan << segment_plan
          accumulated_distance += segment.distance_meters
        end

        race_plan
      end
    end
  end
end
