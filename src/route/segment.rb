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
    last_track_point = @track_points.first
    @track_points.each do |track_point|
      next if track_point.equal? last_track_point
      result += last_track_point.distance_meters_to track_point
      last_track_point = track_point
    end
    result
  end

  def climb
    return 0 if @track_points.length <= 1
    track_points.last.elevation - track_points.first.elevation
  end

  def total_uphills
    return 0 if @track_points.length <= 1

    result = 0
    last_track_point = @track_points.first
    @track_points.each do |track_point|
      if track_point.elevation > last_track_point.elevation
        result += last_track_point.climb_to(track_point)
      end
      last_track_point = track_point
    end
    result
  end

  def total_downhills
    return 0 if @track_points.length <= 1

    result = 0
    last_track_point = @track_points.first
    @track_points.each do |track_point|
      if track_point.elevation < last_track_point.elevation
        result -= last_track_point.climb_to(track_point)
      end
      last_track_point = track_point
    end
    result
  end
end