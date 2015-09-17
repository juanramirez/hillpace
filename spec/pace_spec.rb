require 'rspec'

describe Pace do
  it 'should return the same seconds per km it is initialized with' do
    pace = Pace.from_seconds_per_km 240
    expect(pace.seconds_per_km).to be_within(0.1).of 240
  end

  it 'should return the same meters per second it is initialized with' do
    pace = Pace.from_meters_per_second 2.25
    expect(pace.meters_per_second).to be_within(0.01).of 2.25
  end

  it 'should return the appropriate meters per second when it is initialized with seconds per km' do
    pace = Pace.from_seconds_per_km 264.5
    expect(pace.meters_per_second).to be_within(0.01).of 3.78
  end

  it 'should return the appropriate seconds per km when it is initialized with meters per second' do
    pace = Pace.from_meters_per_second 3.78
    expect(pace.seconds_per_km).to be_within(0.1).of 264.5
  end

  it 'should not return minutes per km if it\'s more than an hour per km' do
    pace = Pace.from_meters_per_second 0.1
    expect { pace.minutes_per_km }.to raise_exception 'Too slow pace: more than an hour per kilometer.'
  end

  it 'should return minutes per km if it\'s less than an hour per km' do
    pace = Pace.from_meters_per_second 3.78
    expect(pace.minutes_per_km).to eq '04:24'
  end
end