require 'rspec'
require_relative '../../src/route/track_point'

describe 'TrackPoint' do
  it 'should raise exception when longitude is tried to be set to a not numeric value' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.longitude = 'invalid' }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new('invalid', 0, 0) }.to raise_exception 'Invalid longitude'
  end

  it 'should raise exception when longitude is tried to be set outside limits' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.longitude = -181 }.to raise_exception 'Invalid longitude'
    expect { track_point.longitude = 181 }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new(-181, 0, 0) }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new(181, 0, 0) }.to raise_exception 'Invalid longitude'
  end

  it 'should not raise exception when longitude is tried to be set to valid values' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.longitude = -180 }.to_not raise_exception
    expect(track_point.longitude).to be(-180)

    expect { track_point.longitude = 180 }.to_not raise_exception
    expect(track_point.longitude).to be(180)

    expect { TrackPoint.new(-180, 0, 0) }.to_not raise_exception
    expect { TrackPoint.new(180, 0, 0) }.to_not raise_exception
  end

  it 'should raise exception when latitude is tried to be set to a not numeric value' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.latitude = 'invalid' }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, 'invalid', 0) }.to raise_exception 'Invalid latitude'
  end

  it 'should raise exception when latitude is tried to be set outside limits' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.latitude = -91 }.to raise_exception 'Invalid latitude'
    expect { track_point.latitude = 91 }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, -91, 0) }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, 91, 0) }.to raise_exception 'Invalid latitude'
  end

  it 'should not raise exception when latitude is tried to be set to valid values' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.latitude = -90 }.to_not raise_exception
    expect(track_point.latitude).to be(-90)

    expect { track_point.latitude = 90 }.to_not raise_exception
    expect(track_point.latitude).to be(90)

    expect { TrackPoint.new(0, -90, 0) }.to_not raise_exception
    expect { TrackPoint.new(0, 90, 0) }.to_not raise_exception
  end

  it 'should raise exception when elevation is tried to be set to a not numeric value' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.elevation = 'invalid' }.to raise_exception 'Invalid elevation'
    expect { TrackPoint.new(0, 0, 'invalid') }.to raise_exception 'Invalid elevation'
  end

  it 'should not raise exception when elevation is tried to be set to a valid value' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { track_point.elevation = 55 }.to_not raise_exception
    expect { TrackPoint.new(0, 0, 55) }.to_not raise_exception
  end
end
