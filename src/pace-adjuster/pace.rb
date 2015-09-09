class Pace
  METERS_PER_KILOMETER = 1000
  SECONDS_IN_AN_HOUR = 3600

  attr_reader :meters_per_second

  def initialize(meters_per_second)
    @meters_per_second = meters_per_second
  end

  def self.from_seconds_per_km(seconds_per_km)
    meters_per_second = METERS_PER_KILOMETER / seconds_per_km.to_f
    new meters_per_second
  end

  def self.from_meters_per_second(meters_per_second)
    new meters_per_second
  end

  def seconds_per_km
    METERS_PER_KILOMETER / @meters_per_second.to_f
  end

  def minutes_per_km
    if seconds_per_km >= SECONDS_IN_AN_HOUR
      raise 'Too slow pace: more than an hour per kilometer.'
    end

    Time.at(seconds_per_km).strftime('%M:%S')
  end

  private_class_method :new
end