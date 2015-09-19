module Hillpace
  class Route
    attr_reader :segments

    def initialize(segments)
      raise 'Invalid segment array to initialize Route' unless segments.respond_to?('each') &&
          segments.all? {|segment| segment.is_a? Segment}

      unless segments.empty?
        last_track_point = segments.first.track_points.first
        segments.each do |segment|
          raise 'Segments must be consecutive' unless last_track_point.equal? segment.track_points.first
          last_track_point = segment.track_points.last
        end
      end

      @segments = segments
    end

    def distance_meters
      segments.inject(0) {|result, segment| result + segment.distance_meters}
    end

    def climb
      segments.inject(0) {|result, segment| result + segment.climb}
    end

    def incline
      self.climb / self.distance_meters
    end

    def total_uphills
      segments.inject(0) {|result, segment| result + segment.total_uphills}
    end

    def total_downhills
      segments.inject(0) {|result, segment| result + segment.total_downhills}
    end

    def split!(distance_meters)
      accumulated_distance = 0

      segments.each_with_index do |segment, index|
        segment_distance = segment.distance_meters
        if accumulated_distance + segment_distance > distance_meters
          subsegments = segment.split (distance_meters - accumulated_distance)
          segments[index] = subsegments
          segments.flatten!
          break
        end
        accumulated_distance += segment_distance
      end
    end
  end
end
