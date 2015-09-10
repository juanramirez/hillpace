require 'rspec'
require_relative '../../src/route/segment'

madrid = TrackPoint.new(-3.6795367, 40.4379543, 648)
chiclana = TrackPoint.new(-6.15084, 36.4118808, 24)
granada = TrackPoint.new(-3.5922032, 37.1809462, 700)
googleplex = TrackPoint.new(-122.0840575, 37.4219999, 6)

describe 'Segment' do
  it 'should not be initialized with anything different than an array' do
    expect { Segment.new(8) }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new(25.2) }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new('foo') }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new(:bar) }.to raise_exception 'Invalid track point array to initialize Segment'
  end

  it 'should not be initialized with an array with anything different than track points' do
    track_point = TrackPoint.new(0, 0, 0)

    expect { Segment.new([track_point, 54]) }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new([track_point, 7.3]) }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new([track_point, 'foo']) }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new([track_point, :bar]) }.to raise_exception 'Invalid track point array to initialize Segment'
  end

  it 'should be initialized with an array of track points' do
    track_point = TrackPoint.new(0, 0, 0)
    expect { Segment.new([track_point]) }.to_not raise_exception
  end

  it 'should give zero distance when all the track points are equal' do
    a = TrackPoint.new(0, 0, 0)
    b = TrackPoint.new(0, 0, 0)
    c = TrackPoint.new(0, 0, 0)

    segment = Segment.new([a, b, c])
    expect(segment.distance_meters).to eq(0)
  end

  it 'should give around 740 km of distance for Madrid - Chiclana - Granada' do
    segment = Segment.new([madrid, chiclana, granada])
    expect(segment.distance_meters).to be_within(5000).of(740000)
  end

  it 'should give 52 meters of climb for Madrid - Chiclana - Granada' do
    segment = Segment.new([madrid, chiclana, granada])
    expect(segment.climb).to eq(52)
  end

  it 'should give 694 meters of total uphills for Madrid - GooglePlex - Granada - Chiclana' do
    segment = Segment.new([madrid, googleplex, granada, chiclana])
    expect(segment.total_uphills).to eq(694)
  end

  it 'should give 1318 meters of total downhills for Madrid - GooglePlex - Granada - Chiclana' do
    segment = Segment.new([madrid, googleplex, granada, chiclana])
    expect(segment.total_downhills).to eq(1318)
  end
end
