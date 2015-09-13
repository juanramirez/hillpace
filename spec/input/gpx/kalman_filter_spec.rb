require 'rspec'
require_relative '../../../src/input/gpx/kalman_filter'

describe 'KalmanFilter' do
  before(:each) do
    @kalman_filter = KalmanFilter.new
    @tp1 = TrackPoint.new 39, -2, 500
    @tp2 = TrackPoint.new 40, -3, 510
    @tp3 = TrackPoint.new 42, -1, 490
    @tp4 = TrackPoint.new 41, -4, 480
    @tp5 = TrackPoint.new 38, 1, 500
  end

  it 'should return a smoothed set of track points' do
    filtered_track_point_1 = @kalman_filter.filter @tp1, Time.new(0)
    expect(filtered_track_point_1).to eq @tp1

    filtered_track_point_2 = @kalman_filter.filter @tp2, Time.new(1)
    expect(filtered_track_point_2.longitude).to be < @tp2.longitude
    expect(filtered_track_point_2.latitude).to be > @tp2.latitude
    expect(filtered_track_point_2.elevation).to be < @tp2.elevation

    filtered_track_point_3 = @kalman_filter.filter @tp3, Time.new(2)
    expect(filtered_track_point_3.longitude).to be < @tp3.longitude
    expect(filtered_track_point_3.latitude).to be < @tp3.latitude
    expect(filtered_track_point_3.elevation).to be > @tp3.elevation

    filtered_track_point_4 = @kalman_filter.filter @tp4, Time.new(3)
    expect(filtered_track_point_4.longitude).to be > @tp4.longitude
    expect(filtered_track_point_4.latitude).to be > @tp4.latitude
    expect(filtered_track_point_4.elevation).to be > @tp4.elevation

    filtered_track_point_5 = @kalman_filter.filter @tp5, Time.new(3)
    expect(filtered_track_point_5.longitude).to be > @tp5.longitude
    expect(filtered_track_point_5.latitude).to be < @tp5.latitude
    expect(filtered_track_point_5.elevation).to be < @tp5.elevation
  end
end
