require 'rspec'
require_relative '../../../src/input/gpx/gpx_parser'

describe 'GpxParser' do
  before(:each) do
    @gpx_file_path = 'spec/resources/gpx/GranadaHalfMarathon.gpx'
  end

  it 'should create a valid route from a gpx document' do
    parser = GpxParser.from_file @gpx_file_path
    routes = parser.parse
    expect(routes.length).to eq 1

    route = routes.first
    expect(route.segments.length).to eq 1
    expect(route.distance_meters).to be_within(500).of 21097

    segment = route.segments.first
    expect(segment.distance_meters).to be_within(500).of 21097
    expect(segment.climb).to be < 10
    expect(segment.total_uphills).to be_within(100).of 450
    expect(segment.total_downhills).to be_within(100).of 450

    first_track_point = segment.track_points.first
    expect(first_track_point.longitude).to be_within(0.001).of -3.5949
    expect(first_track_point.latitude).to be_within(0.001).of 37.1559
    expect(first_track_point.elevation).to be_within(10).of 670

    last_track_point = segment.track_points.last
    expect(last_track_point.longitude).to be_within(0.001).of -3.5939
    expect(last_track_point.latitude).to be_within(0.001).of 37.1567
    expect(last_track_point.elevation).to be_within(10).of 680
  end
end