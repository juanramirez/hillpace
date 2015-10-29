#!/usr/bin/env ruby

require 'hillpace'

class RacePlanner
  include Hillpace
  include Hillpace::Import::Gpx
  include Hillpace::Import::Xml
  include Hillpace::PaceAdjuster
  include Hillpace::PaceAdjuster::Strategies

  def initialize
    @validator = XmlValidator.from_gpx_schema
  end

  def get_adjusted_paces(route_gpx_path, seconds_per_km, split_distances)
    raise 'Invalid gpx file' unless (@validator.validate File.open route_gpx_path).empty?

    parser = GpxParser.from_file route_gpx_path
    routes = parser.parse

    pace_adjuster = PaceAdjuster.new MERVS_RUNNING
    pace = Pace.from_seconds_per_km seconds_per_km

    routes.each do |route|
      route = route.split split_distances
      route.segments.each_with_index do |segment, index|
        incline = segment.incline
        adjusted_pace = pace_adjuster.adjust_pace pace, incline
        puts "Km #{index + 1} (incline #{(incline * 100).round(2)}%): " +
                 "#{adjusted_pace.minutes_per_km} min/km"
      end
    end
  end
end

puts 'Example: Granada Half Marathon (from flat surface pace: 4:00 min/km)'
race_planner = RacePlanner.new
split_distances = (1000..21000).step(1000).to_a
race_planner.get_adjusted_paces 'resources/gpx/GranadaHalfMarathon.gpx', 240, split_distances
