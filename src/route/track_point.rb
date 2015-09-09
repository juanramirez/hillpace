class TrackPoint
  attr_reader :longitude, :latitude, :elevation

  MINIMUM_LONGITUDE = -180
  MAXIMUM_LONGITUDE = 180
  MINIMUM_LATITUDE = -90
  MAXIMUM_LATITUDE = 90

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
    raise 'Invalid elevation' if
        not elevation.is_a? Numeric
    @elevation = elevation
  end
end