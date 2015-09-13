require 'geokit'
require_relative 'track_point'

class Segment
  attr_reader :track_points

  def initialize(track_points)
    raise 'Invalid track point array to initialize Segment' if
        not track_points.respond_to? 'each' or
        track_points.any? {|track_point| not track_point.is_a? TrackPoint}
    @track_points = track_points
  end

  def distance_meters
    return 0 if @track_points.length <= 1

    result = 0
    latest_track_point = @track_points.first
    @track_points.each do |track_point|
      next if track_point.equal? latest_track_point
      result += latest_track_point.distance_meters_to track_point
      latest_track_point = track_point
    end
    result
  end

  def climb
    return 0 if @track_points.length <= 1
    track_points.first.climb_to track_points.last
  end

  def incline
    return 0 if @track_points.length <= 1
    self.climb / self.distance_meters
  end

  def total_uphills
    return 0 if @track_points.length <= 1

    result = 0
    latest_track_point = @track_points.first
    @track_points.each do |track_point|
      if track_point.elevation > latest_track_point.elevation
        result += latest_track_point.climb_to(track_point)
      end
      latest_track_point = track_point
    end
    result
  end

  def total_downhills
    return 0 if @track_points.length <= 1

    result = 0
    latest_track_point = @track_points.first
    @track_points.each do |track_point|
      if track_point.elevation < latest_track_point.elevation
        result -= latest_track_point.climb_to(track_point)
      end
      latest_track_point = track_point
    end
    result
  end

  def split_by_distance_meters(distance_meters)
    result = []
    accumulated_distance = 0
    latest_track_point = @track_points.first
    subsegment_track_points = [latest_track_point]

    @track_points.each_with_index do |track_point, index|
      next if index == 0
      distance_delta = latest_track_point.distance_meters_to track_point
      accumulated_distance += distance_delta

      # in case the distance exceeds the reference distance, we add an interpolated track point
      # both to the end of the actual subsegment and to the start of the next one
      while accumulated_distance > distance_meters
        bias = (distance_meters - (accumulated_distance - distance_delta)) / distance_delta
        interpolated_track_point = latest_track_point.get_linear_interpolation_with track_point, bias
        subsegment_track_points << interpolated_track_point
        result << (Segment.new subsegment_track_points)

        accumulated_distance -= distance_meters
        distance_delta = accumulated_distance
        latest_track_point = interpolated_track_point
        subsegment_track_points = [interpolated_track_point]
      end

      if accumulated_distance == distance_meters or index == @track_points.length - 1
        subsegment_track_points << track_point
        result << (Segment.new subsegment_track_points)
        subsegment_track_points = [track_point]
        latest_track_point = track_point
      elsif accumulated_distance < distance_meters
        subsegment_track_points << track_point
        latest_track_point = track_point
      end
    end

    result
  end
end