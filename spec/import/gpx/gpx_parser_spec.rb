require 'rspec'

describe GpxParser do
  before(:each) do
    @gpx_with_time_path = 'resources/gpx/GranadaHalfMarathon.gpx'
    @gpx_without_time_path = 'resources/gpx/MadridCorrePorMadrid.gpx'
  end

  it 'should create a valid route from a gpx document with time available' do
    parser = GpxParser.from_file @gpx_with_time_path
    routes = parser.parse
    expect(routes.length).to eq 1

    route = routes.first
    expect(route.segments.length).to eq 1
    segment = route.segments.first

    #duck typing here :)
    check_segment route, 21097, 10, 450, 450
    check_segment segment, 21097, 10, 450, 450

    check_track_point segment.track_points.first, -3.5949, 37.1559, 670
    check_track_point segment.track_points.last, -3.5939, 37.1567, 680
  end

  it 'should create a valid route from a gpx document without time available' do
    parser = GpxParser.from_file @gpx_without_time_path
    routes = parser.parse
    expect(routes.length).to eq 1

    route = routes.first
    expect(route.segments.length).to eq 1
    segment = route.segments.first

    #duck typing here :)
    check_segment route, 10000, 10, 200, 200
    check_segment segment, 10000, 10, 200, 200

    check_track_point segment.track_points.first, -3.6791, 40.4192, 685
    check_track_point segment.track_points.last, -3.6800, 40.4159, 675
  end

  def check_segment(segment, distance_meters, climb, total_uphills, total_downhills)
    expect(segment.distance_meters).to be_within(250).of distance_meters
    expect(segment.climb).to be < climb
    expect(segment.total_uphills).to be_within(100).of total_uphills
    expect(segment.total_downhills).to be_within(100).of total_downhills
  end

  def check_track_point(track_point, longitude, latitude, elevation)
    expect(track_point.longitude).to be_within(0.001).of longitude
    expect(track_point.latitude).to be_within(0.001).of latitude
    expect(track_point.elevation).to be_within(10).of elevation
  end
end