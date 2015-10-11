require 'rspec'

describe Segment do
  before(:each) do
    @madrid = TrackPoint.new -3.6795367, 40.4379543, 648
    @cadiz = TrackPoint.new -6.283333, 36.516667, 17, Time.new(2015, 10, 1, 10)
    @chiclana = TrackPoint.new -6.15084, 36.4118808, 24, Time.new(2015, 10, 1, 11, 30)
    @puerto_real = TrackPoint.new -6.191944, 36.529167, 12
    @jerez = TrackPoint.new -6.116667, 36.7, 43
    @granada = TrackPoint.new -3.5922032, 37.1809462, 700
    @veleta = TrackPoint.new -3.348333, 37.050556, 3396
    @googleplex = TrackPoint.new -122.0840575, 37.4219999, 6
  end

  it 'should not be initialized with anything different than an array' do
    expect { Segment.new 8 }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new 25.2 }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new 'foo' }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new :bar }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new @googleplex }.to raise_exception 'Invalid track point array to initialize Segment'
  end

  it 'should not be initialized with an array with anything different than track points' do
    expect { Segment.new [@googleplex, 54] }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new [@googleplex, 7.3] }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new [@googleplex, 'foo'] }.to raise_exception 'Invalid track point array to initialize Segment'
    expect { Segment.new [@googleplex, :bar] }.to raise_exception 'Invalid track point array to initialize Segment'
  end

  it 'should be initialized with an array of track points' do
    expect { Segment.new [@googleplex] }.to_not raise_exception
  end

  it 'should give zero distance when all the track points are equal' do
    segment = Segment.new [@googleplex, @googleplex, @googleplex]
    expect(segment.distance_meters).to eq 0
  end

  it 'should give around 740 km of distance for Madrid - Chiclana - Granada' do
    segment = Segment.new [@madrid, @chiclana, @granada]
    expect(segment.distance_meters).to be_within(5000).of 740000
  end

  it 'should be splitted into two segments when segment distance is larger than the given one' do
    segment = Segment.new [@chiclana, @cadiz, @puerto_real, @jerez]
    subsegments = segment.split 1000
    expect(subsegments.length).to eq 2

    expect(subsegments.first.track_points.length).to eq 2
    expect(subsegments.last.track_points.length).to eq 4

    # Linear interpolation is ok for normal track point frequency, but for just four points and several km away
    # it's assumable to have a +-1 meter error.
    expect(subsegments.first.distance_meters).to be_within(1).of 1000
    expect(subsegments.last.distance_meters).to be_within(1).of (segment.distance_meters - 1000)
  end

  it 'should return an array with the input segment when segment distance is shorter than the given one' do
    segment = Segment.new [@chiclana, @cadiz, @puerto_real, @jerez]
    segment_distance = segment.distance_meters
    subsegments = segment.split (segment_distance + 1)
    expect(subsegments.length).to eq 1
    expect(subsegments.first).to eq segment
  end

  it 'should give 52 meters of climb for Madrid - Chiclana - Granada' do
    segment = Segment.new [@madrid, @chiclana, @granada]
    expect(segment.climb).to eq 52
  end

  it 'should give 10% of incline for Granada - Veleta' do
    segment = Segment.new [@granada, @veleta]
    expect(segment.incline).to be_within(0.01).of 0.10
  end

  it 'should give 694 meters of total uphills for Madrid - GooglePlex - Granada - Chiclana' do
    segment = Segment.new [@madrid, @googleplex, @granada, @chiclana]
    expect(segment.total_uphills).to eq 694
  end

  it 'should give 1318 meters of total downhills for Madrid - GooglePlex - Granada - Chiclana' do
    segment = Segment.new [@madrid, @googleplex, @granada, @chiclana]
    expect(segment.total_downhills).to eq 1318
  end

  it 'should give 5400 seconds of duration for Cádiz - Chiclana' do
    segment = Segment.new [@cadiz, @chiclana]
    expect(segment.duration).to eq 5400
  end

  it 'should give a pace of around 5:30 min/km for Cádiz - Chiclana' do
    segment = Segment.new [@cadiz, @chiclana]
    expect(segment.pace.seconds_per_km).to be_within(10).of 330
  end
end
