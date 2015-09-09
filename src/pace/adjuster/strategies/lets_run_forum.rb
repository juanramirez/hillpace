#source: http://www.letsrun.com/forum/flat_read.php?thread=197366&page=0
LETS_RUN_FORUM = lambda do |pace, incline|
  division_factor = 1.0 + (incline * 9)
  Pace.from_meters_per_second(pace.meters_per_second / division_factor)
end
