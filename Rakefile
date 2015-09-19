require 'bundler/gem_tasks'
require_relative 'example'

task :default => [:test]

task :test do
  sh 'rspec spec/ --fail-fast'
end

task :example do
  example = Example.new
  example.get_adjusted_paces 'spec/resources/gpx/GranadaHalfMarathon.gpx', 240
end
