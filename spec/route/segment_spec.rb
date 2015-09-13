require 'rspec'
require_relative '../../src/route/segment'

describe 'Segment' do
  before(:each) do
    @madrid = TrackPoint.new -3.6795367, 40.4379543, 648
    @chiclana = TrackPoint.new -6.15084, 36.4118808, 24
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

  it 'should be splitted into 740 or 741 segments of (approx.) 1km of distance for Madrid - Chiclana - Granada' do
    segment = Segment.new [@madrid, @chiclana, @granada]
    subsegments = segment.split_by_distance_meters 1000
    expect(subsegments.length).to be_between 740, 741

    subsegments.each_with_index do |subsegment, index|
      break if index == subsegments.length - 1
      # Linear interpolation is ok for normal track point frequency, but for just three points and so far away
      # it's assumable to have a +-10 meters error.
      expect(subsegment.distance_meters).to be_within(10).of 1000
    end

    subsegments.each_with_index do |subsegment, index|
      next if index == 0
      expect(subsegment.track_points.first).to eq subsegments[index - 1].track_points.last
    end
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
end
