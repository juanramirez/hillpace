require 'rspec'

describe PaceAdjuster do
  it 'should use the provided strategy' do
    pace = Pace.from_seconds_per_km 240
    incline = 0.15

    dummy_result = Pace.from_seconds_per_km 500
    strategy = lambda {|_pace, _incline| dummy_result}
    expect(strategy).to receive(:call).with(pace, incline).and_call_original

    pace_adjuster = PaceAdjuster.new strategy
    adjusted_pace = pace_adjuster.adjust_pace pace, incline
    expect(adjusted_pace.seconds_per_km).to eq 500
  end
end
