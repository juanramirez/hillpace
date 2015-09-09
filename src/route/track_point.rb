require 'geokit'

class TrackPoint
  attr_reader :longitude, :latitude, :elevation

  MINIMUM_LONGITUDE = -180
  MAXIMUM_LONGITUDE = 180
  MINIMUM_LATITUDE = -90
  MAXIMUM_LATITUDE = 90

  METERS_PER_KILOMETER = 1000

  def initialize(longitude, latitude, elevation)
    self.longitude = longitude
    self.latitude = latitude
    self.elevation = elevation
  end

  def longitude=(longitude)
    raise 'Invalid longitude' if
        not longitude.is_a? Numeric or
        longitude < MINIMUM_LONGITUDE or
        longitude > MAXIMUM_LONGITUDE
    @longitude = longitude
  end

  def latitude=(latitude)
    raise 'Invalid latitude' if
        not latitude.is_a? Numeric or
        latitude < MINIMUM_LATITUDE or
        latitude > MAXIMUM_LATITUDE
    @latitude = latitude
  end

  def elevation=(elevation)
    raise 'Invalid elevation' unless elevation.is_a? Numeric
    @elevation = elevation
  end

  def distance_meters_to(track_point)
    raise 'Invalid track point' unless track_point.is_a? TrackPoint
    a = Geokit::GeoLoc.new({:lat => @latitude, :lng => @longitude})
    b = Geokit::GeoLoc.new({:lat => track_point.latitude, :lng => track_point.longitude})
    METERS_PER_KILOMETER * (a.distance_to b, {:units => :kms})
  end

  def climb_to(track_point)
    track_point.elevation - @elevation
  end
end