module Hillpace
  # Represents a geographic route in the Earth, made out of consecutive segments.
  class Route
    attr_reader :segments

    # Initializes a Route object.
    # @param segments [Array<Segment>] The segments of the route.
    # @raise [RuntimeError] if _segments_ is not a collection of [Segment] objects.
    # @raise [RuntimeError] if any of the _segments_ start is not the same point of the previous segment
    #   end.
    def initialize(segments)
      raise 'Invalid segment array to initialize Route' unless segments.respond_to?('each') &&
          segments.all? {|segment| segment.is_a? Segment}

      unless segments.empty?
        last_track_point = segments.first.track_points.first
        segments.each do |segment|
          raise 'Segments must be consecutive' unless last_track_point == segment.track_points.first
          last_track_point = segment.track_points.last
        end
      end

      @segments = segments
    end

    # Measures the distance of the route, in meters.
    # @return [Number]
    def distance_meters
      segments.inject(0) {|result, segment| result + segment.distance_meters}
    end

    # Measures the elevation difference from the start to the end of the route, in meters.
    # @return [Number]
    def climb
      segments.inject(0) {|result, segment| result + segment.climb}
    end

    # Measures the climb of the route relative to its distance.
    # @return [Number]
    def incline
      self.climb / self.distance_meters
    end

    # Measures the sum of uphills between segments of the route.
    # @return [Number]
    def total_uphills
      segments.inject(0) {|result, segment| result + segment.total_uphills}
    end

    # Measures the sum of downhills between segments of the route.
    # @return [Number]
    def total_downhills
      segments.inject(0) {|result, segment| result + segment.total_downhills}
    end

    # Measures the duration of the route, in seconds.
    # @return [Number]
    def duration
      segments.inject(0) {|result, segment| result + segment.duration}
    end

    # Measures the pace of the route.
    # @return [Pace]
    def pace
      Pace.from_meters_per_second(distance_meters / duration)
    end

    # Splits the segments in the route in the distances indicated.
    # @param split_distances [Array<Number>] Distances where the segments of the route should be splitted.
    # @return [Route] A copy of this route, with splitted segments
    def split(split_distances)
      split_distances_enumerator = split_distances.sort.each
      next_split_distance = split_distances_enumerator.next
      accumulated_distance = 0
      result = []

      segments.lazy.each do |segment|
        while next_split_distance < accumulated_distance + segment.distance_meters
          subsegments = segment.split (next_split_distance - accumulated_distance)
          result << subsegments.first
          accumulated_distance += subsegments.first.distance_meters
          if subsegments.length > 1
            segment = subsegments.last
            next_split_distance = split_distances_enumerator.next rescue Float::INFINITY
          end
        end
        result << segment.clone
        accumulated_distance += segment.distance_meters
      end

      Route.new result
    end
  end
end
