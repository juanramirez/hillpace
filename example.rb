require 'hillpace'

class Example
  include Hillpace
  include Hillpace::Input::Gpx
  include Hillpace::PaceAdjuster
  include Hillpace::PaceAdjuster::Strategies

  def initialize
    @validator = GpxValidator.from_default_schema
  end

  def get_adjusted_paces(route_gpx_path, seconds_per_km)
    raise 'Invalid gpx file' unless (@validator.validate File.open route_gpx_path).empty?

    parser = GpxParser.from_file route_gpx_path
    routes = parser.parse

    pace_adjuster = PaceAdjuster.new MERVS_RUNNING
    pace = Pace.from_seconds_per_km seconds_per_km

    puts 'Example: Granada Half Marathon (from flat surface pace: 4:00 min/km)'
    routes.each do |route|

      distance = 1000
      loop do
        route_segments_count = route.segments.length
        route.split! distance
        distance += 1000
        break if route_segments_count == route.segments.length
      end

      route.segments.each_with_index do |segment, index|
        incline = segment.incline
        adjusted_pace = pace_adjuster.adjust_pace pace, incline
        puts "Km #{index + 1} (incline #{(incline * 100).round(2)}%): " +
                 "#{adjusted_pace.minutes_per_km} min/km"
      end
    end
  end
end

