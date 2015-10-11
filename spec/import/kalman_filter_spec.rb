require 'rspec'

describe KalmanFilter do
  before(:each) do
    @kalman_filter = KalmanFilter.new
    @tp1 = TrackPoint.new 39, -2, 500, Time.new(0)
    @tp2 = TrackPoint.new 40, -3, 510, Time.new(1)
    @tp3 = TrackPoint.new 42, -1, 490, Time.new(2)
    @tp4 = TrackPoint.new 41, -4, 480, Time.new(3)
    @tp5 = TrackPoint.new 38, 1, 500, Time.new(3)
  end

  it 'should return a smoothed set of track points' do
    filtered_track_point_1 = @kalman_filter.apply @tp1
    expect(filtered_track_point_1).to eq @tp1

    filtered_track_point_2 = @kalman_filter.apply @tp2
    expect(filtered_track_point_2.longitude).to be < @tp2.longitude
    expect(filtered_track_point_2.latitude).to be > @tp2.latitude
    expect(filtered_track_point_2.elevation).to be < @tp2.elevation

    filtered_track_point_3 = @kalman_filter.apply @tp3
    expect(filtered_track_point_3.longitude).to be < @tp3.longitude
    expect(filtered_track_point_3.latitude).to be < @tp3.latitude
    expect(filtered_track_point_3.elevation).to be > @tp3.elevation

    filtered_track_point_4 = @kalman_filter.apply @tp4
    expect(filtered_track_point_4.longitude).to be > @tp4.longitude
    expect(filtered_track_point_4.latitude).to be > @tp4.latitude
    expect(filtered_track_point_4.elevation).to be > @tp4.elevation

    filtered_track_point_5 = @kalman_filter.apply @tp5
    expect(filtered_track_point_5.longitude).to be > @tp5.longitude
    expect(filtered_track_point_5.latitude).to be < @tp5.latitude
    expect(filtered_track_point_5.elevation).to be < @tp5.elevation
  end
end
