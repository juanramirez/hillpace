require_relative 'lib/hillpace/input/gpx/gpx_validator'
require_relative 'lib/hillpace/input/gpx/gpx_parser'
require_relative 'lib/hillpace/pace_adjuster/pace_adjuster'
require_relative 'lib/hillpace/pace_adjuster/strategies/mervs_running'

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
      route.segments.each_with_index do |segment|
        subsegments = segment.split_by_distance_meters 1000

        subsegments.each_with_index do |subsegment, subsegment_index|
          incline = subsegment.incline
          adjusted_pace = pace_adjuster.adjust_pace pace, incline
          puts "Km #{subsegment_index + 1} (incline #{(incline * 100).round(2)}%): " +
            "#{adjusted_pace.minutes_per_km} min/km"
        end
      end
    end
  end
end

