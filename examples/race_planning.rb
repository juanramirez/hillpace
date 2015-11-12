#!/usr/bin/env ruby

require 'hillpace'

include Hillpace
include Hillpace::Import::Gpx
include Hillpace::Import::Xml
include Hillpace::PaceAdjuster
include Hillpace::PaceAdjuster::Strategies
include Hillpace::RacePlanner

def get_route(gpx_path)
  validator = XmlValidator.from_gpx_schema
  raise 'Invalid gpx file' unless (validator.validate File.open gpx_path).empty?

  parser = GpxParser.from_file gpx_path
  routes = parser.parse

  routes.first
end

route = get_route('resources/gpx/GranadaHalfMarathon.gpx')
split_distances = (1000..21000).step(1000).to_a
reference_pace = Pace.from_seconds_per_km 248

race_planner = RacePlanner.new MERVS_RUNNING
race_plan = race_planner.plan_race route, split_distances, reference_pace

puts 'Example: Granada Half Marathon (from flat surface pace: 4:08 min/km)'
race_plan.each do |segment_plan|
  puts "#{((segment_plan[:segment_start])/1000).round(2)}Km - " +
           "#{((segment_plan[:segment_end])/1000).round(2)}Km " +
           "(incline #{(segment_plan[:incline] * 100).round(2)}%): " +
           "#{segment_plan[:adjusted_pace].minutes_per_km} min/km"
end
