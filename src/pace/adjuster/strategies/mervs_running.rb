# source: http://merv.stanford.edu/runcalc?Request=explanation
MERVS_RUNNING = lambda do |pace, incline|
  division_factor = 1.0 - (incline * 4.5)
  Pace.from_seconds_per_km(pace.seconds_per_km / division_factor)
end