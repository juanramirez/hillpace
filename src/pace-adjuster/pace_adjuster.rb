class PaceAdjuster
  def initialize(strategy)
    @strategy = strategy
  end

  def adjust_pace(pace, incline)
    @strategy.call pace, incline
  end
end