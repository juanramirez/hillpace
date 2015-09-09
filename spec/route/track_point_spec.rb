require 'rspec'
require_relative '../../src/route/track_point'

madrid = TrackPoint.new(-3.6795367, 40.4379543, 648)
chiclana = TrackPoint.new(-6.15084, 36.4118808, 24)
googleplex = TrackPoint.new(-122.0840575, 37.4219999, 6)

describe 'TrackPoint' do
  it 'should raise exception when longitude is tried to be set to a not numeric value' do
    expect { googleplex.longitude = 'invalid' }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new('invalid', 0, 0) }.to raise_exception 'Invalid longitude'
  end

  it 'should raise exception when longitude is tried to be set outside limits' do
    expect { googleplex.longitude = -181 }.to raise_exception 'Invalid longitude'
    expect { googleplex.longitude = 181 }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new(-181, 0, 0) }.to raise_exception 'Invalid longitude'
    expect { TrackPoint.new(181, 0, 0) }.to raise_exception 'Invalid longitude'
  end

  it 'should not raise exception when longitude is tried to be set to valid values' do
    expect { googleplex.longitude = -180 }.to_not raise_exception
    expect(googleplex.longitude).to be(-180)

    expect { googleplex.longitude = 180 }.to_not raise_exception
    expect(googleplex.longitude).to be(180)

    expect { TrackPoint.new(-180, 0, 0) }.to_not raise_exception
    expect { TrackPoint.new(180, 0, 0) }.to_not raise_exception
  end

  it 'should raise exception when latitude is tried to be set to a not numeric value' do
    expect { googleplex.latitude = 'invalid' }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, 'invalid', 0) }.to raise_exception 'Invalid latitude'
  end

  it 'should raise exception when latitude is tried to be set outside limits' do
    expect { googleplex.latitude = -91 }.to raise_exception 'Invalid latitude'
    expect { googleplex.latitude = 91 }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, -91, 0) }.to raise_exception 'Invalid latitude'
    expect { TrackPoint.new(0, 91, 0) }.to raise_exception 'Invalid latitude'
  end

  it 'should not raise exception when latitude is tried to be set to valid values' do
    expect { googleplex.latitude = -90 }.to_not raise_exception
    expect(googleplex.latitude).to be(-90)

    expect { googleplex.latitude = 90 }.to_not raise_exception
    expect(googleplex.latitude).to be(90)

    expect { TrackPoint.new(0, -90, 0) }.to_not raise_exception
    expect { TrackPoint.new(0, 90, 0) }.to_not raise_exception
  end

  it 'should raise exception when elevation is tried to be set to a not numeric value' do
    expect { googleplex.elevation = 'invalid' }.to raise_exception 'Invalid elevation'
    expect { TrackPoint.new(0, 0, 'invalid') }.to raise_exception 'Invalid elevation'
  end

  it 'should not raise exception when elevation is tried to be set to a valid value' do
    expect { googleplex.elevation = 55 }.to_not raise_exception
    expect { TrackPoint.new(0, 0, 55) }.to_not raise_exception
  end

  it 'should return zero distance for the same track point' do
    expect(googleplex.distance_meters_to googleplex).to eq(0)
  end

  it 'should return around 500 km of distance between Chiclana and Madrid' do
    expect(chiclana.distance_meters_to madrid).to be_within(5000).of(500000)
  end

  it 'should return zero climb for the same track point' do
    expect(googleplex.climb_to googleplex).to eq(0)
  end

  it 'should return 624 meters of climb from Chiclana to Madrid' do
    expect(chiclana.climb_to madrid).to eq(624)
  end

  it 'should return -624 meters of climb from Madrid to Chiclana' do
    expect(madrid.climb_to chiclana).to eq(-624)
  end
end
