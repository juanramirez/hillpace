require 'geokit'

module Hillpace
  # Represents a geographic segment in the Earth, made out of sorted track points.
  class Segment
    attr_reader :track_points

    # Initializes a Segment object.
    # @param track_points [Array<TrackPoint>] The track points of the segment.
    # @raise [RuntimeError] if _track_points_ is not a collection of [TrackPoint]
    #   objects.
    def initialize(track_points)
      raise 'Invalid track point array to initialize Segment' unless track_points.respond_to?('each') &&
          track_points.all? {|track_point| track_point.is_a? TrackPoint}
      @track_points = track_points
    end

    # Overwrites the #== operator to be able to use custom getters.
    # @param other [Segment] The other segment to be compared.
    # @return [boolean]
    def ==(other)
      self.class == other.class &&
          track_points == other.track_points
    end

    # Measures the distance of the segment, in meters.
    # @return [Number]
    def distance_meters
      return 0 if track_points.length <= 1

      result = 0
      latest_track_point = track_points.first
      track_points.each do |track_point|
        next if track_point.equal? latest_track_point
        result += latest_track_point.distance_meters_to track_point
        latest_track_point = track_point
      end
      result
    end

    # Measures the elevation difference from the start to the end of the segment, in meters.
    # @return [Number]
    def climb
      return 0 if track_points.length <= 1
      track_points.first.climb_to track_points.last
    end

    # Measures the climb of the segment relative to its distance.
    # @return [Number]
    def incline
      return 0 if track_points.length <= 1
      self.climb / self.distance_meters
    end

    # Measures the sum of uphills between track points of the segment.
    # @return [Number]
    def total_uphills
      return 0 if track_points.length <= 1

      result = 0
      latest_track_point = track_points.first
      track_points.each do |track_point|
        if track_point.elevation > latest_track_point.elevation
          result += latest_track_point.climb_to(track_point)
        end
        latest_track_point = track_point
      end
      result
    end

    # Measures the sum of downhills between track points of the segment.
    # @return [Number]
    def total_downhills
      return 0 if track_points.length <= 1

      result = 0
      latest_track_point = track_points.first
      track_points.each do |track_point|
        if track_point.elevation < latest_track_point.elevation
          result -= latest_track_point.climb_to(track_point)
        end
        latest_track_point = track_point
      end
      result
    end

    # Measures the duration of the segment, in seconds.
    # @return [Number]
    def duration
      track_points.last.time.to_f - track_points.first.time.to_f
    end

    # Measures the pace of the segment.
    # @return [Pace]
    def pace
      Pace.from_meters_per_second(distance_meters / duration)
    end

    # Returns an array of segments, result of splitting _self_ in the distance indicated.
    # @param distance_meters [Number] The distance in the segment where it should be splitted.
    # @return [Array<Segment>]
    def split(distance_meters)
      result = []
      accumulated_distance = 0
      latest_track_point = track_points.first
      subsegment_track_points = [latest_track_point]

      track_points.lazy.each_with_index do |track_point, index|
        next if index == 0
        distance_delta = latest_track_point.distance_meters_to track_point
        accumulated_distance += distance_delta

        if result.empty?
          # in case the distance exceeds the reference distance, we add an interpolated track point
          # both to the end of the actual subsegment and to the start of the next one
          if accumulated_distance > distance_meters
            bias = (distance_meters - (accumulated_distance - distance_delta)) / distance_delta
            interpolated_track_point = latest_track_point.get_linear_interpolation_with track_point, bias
            subsegment_track_points << interpolated_track_point
            result << (Segment.new subsegment_track_points)
            subsegment_track_points = [interpolated_track_point]
          end
        end

        subsegment_track_points << track_point.clone
        latest_track_point = track_point
      end

      result << (Segment.new subsegment_track_points)
    end
  end
end
