require 'geokit'

module Hillpace
  # Represents a geographic track point in the Earth.
  class TrackPoint
    attr_reader :longitude, :latitude, :elevation

    MINIMUM_LONGITUDE = -180
    MAXIMUM_LONGITUDE = 180
    MINIMUM_LATITUDE = -90
    MAXIMUM_LATITUDE = 90

    METERS_PER_KILOMETER = 1000

    # Initializes a TrackPoint object.
    # @param longitude [Number] The geographic longitude of the track point.
    # @param latitude [Number] The geographic latitude of the track point.
    # @param elevation [Number] The elevation of the track point relative to sea level.
    def initialize(longitude, latitude, elevation)
      self.longitude = longitude
      self.latitude = latitude
      self.elevation = elevation
    end

    # Overwrites the #== operator to be able to use custom getters.
    # @param other [TrackPoint] The other track point to be compared.
    # @return [boolean]
    def ==(other)
      self.class  == other.class &&
          longitude   == other.longitude &&
          latitude    == other.latitude &&
          elevation   == other.elevation
    end

    # Setter for the longitude class member.
    # @param longitude [Number] The longitude value to be set.
    # @raise [RuntimeError] if _longitude_ is invalid
    def longitude=(longitude)
      raise 'Invalid longitude' unless
          longitude.is_a?(Numeric) &&
              longitude >= MINIMUM_LONGITUDE &&
              longitude <= MAXIMUM_LONGITUDE
      @longitude = longitude
    end

    # Setter for the latitude class member.
    # @param latitude [Number] The latitude value to be set.
    # @raise [RuntimeError] if _latitude_ is invalid
    def latitude=(latitude)
      raise 'Invalid latitude' unless
          latitude.is_a?(Numeric) &&
              latitude >= MINIMUM_LATITUDE &&
              latitude <= MAXIMUM_LATITUDE
      @latitude = latitude
    end

    # Setter for the elevation class member.
    # @param elevation [Number] The elevation value to be set.
    # @raise [RuntimeError] if _elevation_ is not Numeric
    def elevation=(elevation)
      raise 'Invalid elevation' unless elevation.is_a? Numeric
      @elevation = elevation
    end

    # Measures the distance to other track point, in meters.
    # @param other [TrackPoint] The other track point to compare.
    # @raise [RuntimeError] if _other_ is not a TrackPoint object
    # @return [Number]
    def distance_meters_to(other)
      raise 'Invalid track point' unless other.is_a? TrackPoint
      a = Geokit::GeoLoc.new({:lat => latitude, :lng => longitude})
      b = Geokit::GeoLoc.new({:lat => other.latitude, :lng => other.longitude})
      METERS_PER_KILOMETER * (a.distance_to b, {:units => :kms})
    end

    # Measures the elevation difference to other track point, in meters.
    # @param other [TrackPoint] The other track point to compare.
    # @raise [RuntimeError] if _other_ is not a TrackPoint object
    # @return [Number]
    def climb_to(other)
      raise 'Invalid track point' unless other.is_a? TrackPoint
      other.elevation - elevation
    end

    # Measures the elevation difference to other track point relative to the distance to it.
    # @param other [TrackPoint] The other track point to compare.
    # @raise [RuntimeError] if _other_ is not a TrackPoint object
    # @return [Number]
    def incline_to(other)
      raise 'Invalid track point' unless other.is_a? TrackPoint
      distance_meters = self.distance_meters_to other
      return 0 if distance_meters == 0

      (self.climb_to other) / distance_meters
    end

    # Returns a linear interpolation between _self_ and the one provided.
    # @note For small distances between track points, a linear interpolation should be accurate enough.
    # @param other [TrackPoint] The other track point to compare.
    # @param bias [Number] Value which will determine the position in that line. *0* would be the position of _self_,
    #   *1* would be _other_ position.
    # @raise [Runtimeerror] if _other_ is not a TrackPoint object
    # @return [Number]
    def get_linear_interpolation_with(other, bias = 0.5)
      raise 'Invalid track point' unless other.is_a? TrackPoint
      TrackPoint.new longitude * (1.0 - bias) + other.longitude * bias,
                     latitude * (1.0 - bias) + other.latitude * bias,
                     elevation * (1.0 - bias) + other.elevation * bias
    end
  end
end
