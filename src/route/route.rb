class Route
  attr_reader :segments

  def initialize(segments)
    raise 'Invalid segment array to initialize Route' if
        not segments.respond_to? 'each' or
            segments.any? {|segment| not segment.is_a? Segment}

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
    @segments.inject(0) {|result, segment| result + segment.distance_meters}
  end

  def climb
    @segments.inject(0) {|result, segment| result + segment.climb}
  end
end