require_relative 'example'

task :default => [:test]

task :test do
  sh 'bin/rspec spec/ --fail-fast'
end

task :example do
  route_pace_adjuster = Example.new
  route_pace_adjuster.get_adjusted_paces 'spec/resources/gpx/GranadaHalfMarathon.gpx', 240
end
