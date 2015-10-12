require 'rspec'

describe TcxParser do
  before(:each) do
    @tcx_path = 'resources/tcx/2015-08-16_CarreraAtenasPlaya.tcx'
  end

  it 'should create a valid route from a tcx document with time available' do
    parser = TcxParser.from_file @tcx_path
    routes = parser.parse
    expect(routes.length).to eq 1

    route = routes.first
    expect(route.segments.length).to eq 8
    segment = route.segments.first

    #duck typing here :)
    check_segment route, 8000, 10, 20, 20
    check_segment segment, 1000, 2, 5, 5

    check_track_point segment.track_points.first, -6.1653, 36.3393, 0
    check_track_point segment.track_points.last, -6.1694, 36.3476, 0
  end

  def check_segment(segment, distance_meters, climb, total_uphills, total_downhills)
    expect(segment.distance_meters).to be_within(150).of distance_meters
    expect(segment.climb).to be < climb
    expect(segment.total_uphills).to be_within(25).of total_uphills
    expect(segment.total_downhills).to be_within(25).of total_downhills
  end

  def check_track_point(track_point, longitude, latitude, elevation)
    expect(track_point.longitude).to be_within(0.001).of longitude
    expect(track_point.latitude).to be_within(0.001).of latitude
    expect(track_point.elevation).to be_within(5).of elevation
  end
end
