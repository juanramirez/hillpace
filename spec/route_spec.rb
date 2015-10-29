require 'rspec'

describe Route do
  before(:each) do
    @madrid = TrackPoint.new -3.6795367, 40.4379543, 648
    @cadiz = TrackPoint.new -6.283333, 36.516667, 11, Time.new(2015, 10, 1, 10)
    @chiclana = TrackPoint.new -6.15084, 36.4118808, 24
    @puerto_real = TrackPoint.new -6.191944, 36.529167, 12, Time.new(2015, 10, 1, 10, 50)
    @jerez = TrackPoint.new -6.116667, 36.7, 43, Time.new(2015, 10, 1, 12, 30)
    @granada = TrackPoint.new -3.5922032, 37.1809462, 700
    @new_york = TrackPoint.new -73.94, 40.67, 10
    @googleplex = TrackPoint.new -122.0840575, 37.4219999, 6

    @chiclana_googleplex = Segment.new [@chiclana, @cadiz, @granada, @madrid, @new_york, @googleplex]
    @granada_new_york = Segment.new [@granada, @cadiz, @granada, @madrid, @googleplex, @new_york]
    @googleplex_madrid = Segment.new [@googleplex, @granada, @madrid]
    @chiclana_cadiz = Segment.new [@chiclana, @cadiz]
    @cadiz_jerez = Segment.new [@cadiz, @puerto_real, @jerez]

    @chiclana_madrid = Route.new [@chiclana_googleplex, @googleplex_madrid]
    @chiclana_jerez = Route.new [@chiclana_cadiz, @cadiz_jerez]
  end

  it 'should not be initialized with anything different than an array' do
    expect { Route.new 8 }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new 25.2 }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new 'foo' }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new :bar }.to raise_exception 'Invalid segment array to initialize Route'
  end

  it 'should not be initialized with an array with anything different than segments' do
    expect { Route.new [@chiclana_googleplex, 54] }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new [@chiclana_googleplex, 7.3] }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new [@chiclana_googleplex, 'foo'] }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new [@chiclana_googleplex, :bar] }.to raise_exception 'Invalid segment array to initialize Route'
    expect { Route.new [@chiclana_googleplex, @googleplex] }.to \
    raise_exception 'Invalid segment array to initialize Route'
  end

  it 'should be initialized with an array of segments' do
    expect { Route.new [@chiclana_googleplex] }.to_not raise_exception
  end

  it 'should raise an exception when segments are not consecutive' do
    expect { Route.new [@chiclana_googleplex, @granada_new_york] }.to raise_exception 'Segments must be consecutive'
  end

  it 'should give a distance which is the sum of the distances of all segments' do
    expect(@chiclana_madrid.distance_meters).to \
    eq @chiclana_googleplex.distance_meters + @googleplex_madrid.distance_meters
  end

  it 'should give a climb which is the sum of the climbs of all segments' do
    expect(@chiclana_madrid.climb).to eq @chiclana_googleplex.climb + @googleplex_madrid.climb
  end

  it 'should give an incline which is the sum of the climbs divided by the sum of the distances of all segments' do
    climb_sum = @chiclana_googleplex.climb + @googleplex_madrid.climb
    distance_meters_sum = @chiclana_googleplex.distance_meters + @googleplex_madrid.distance_meters
    expect(@chiclana_madrid.incline).to eq (climb_sum / distance_meters_sum)
  end

  it 'should give total uphills data which is the sum of the total uphills of all segments' do
    expect(@chiclana_madrid.total_uphills).to eq @chiclana_googleplex.total_uphills + @googleplex_madrid.total_uphills
  end

  it 'should give total downhills data which is the sum of the total downhills of all segments' do
    expect(@chiclana_madrid.total_downhills).to \
    eq @chiclana_googleplex.total_downhills + @googleplex_madrid.total_downhills
  end

  it 'should give 9000 seconds of duration for Cádiz - Jerez' do
    expect(@cadiz_jerez.duration).to eq 9000
  end

  it 'should give a pace of around 5:15 min/km for Cádiz - Jerez' do
    expect(@cadiz_jerez.pace.seconds_per_km).to be_within(10).of 315
  end

  it 'should be splitted if distance is shorter than the total route distance' do
    expect((@chiclana_jerez.split [1000, 2000]).segments.length).to eq 4
  end

  it 'should not be splitted if distance is longer than the total route distance' do
    expect((@chiclana_jerez.split [100000]).segments.length).to eq 2
  end

end
