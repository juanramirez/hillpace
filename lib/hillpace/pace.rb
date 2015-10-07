module Hillpace
  # Represents a pace.
  class Pace
    METERS_PER_KILOMETER = 1000
    SECONDS_IN_AN_HOUR = 3600

    attr_reader :meters_per_second

    # Inicializes a Pace object.
    # @param meters_per_second [Number] The pace expressed in meters per second.
    def initialize(meters_per_second)
      @meters_per_second = meters_per_second
    end

    # Creates a new Pace object from a pace expressed in seconds per kilometer.
    # @param seconds_per_km [Number] The pace expressed in seconds per kilometer.
    def self.from_seconds_per_km(seconds_per_km)
      meters_per_second = METERS_PER_KILOMETER / seconds_per_km.to_f
      new meters_per_second
    end

    # Creates a new Pace object from a pace expressed in meters per second.
    # @param meters_per_second [Number] The pace expressed in meters per second.
    def self.from_meters_per_second(meters_per_second)
      new meters_per_second
    end

    # Returns the pace in seconds per kilometer.
    # @return [Number]
    def seconds_per_km
      METERS_PER_KILOMETER / @meters_per_second.to_f
    end

    # Returns the pace in minutes per kilometer.
    # @return [String]
    # @raise [RuntimeError] if the pace is slower than an hour per kilometer.
    def minutes_per_km
      if seconds_per_km >= SECONDS_IN_AN_HOUR
        raise 'Too slow pace: more than an hour per kilometer.'
      end

      Time.at(seconds_per_km).strftime '%M:%S'
    end

    private_class_method :new
  end
end
