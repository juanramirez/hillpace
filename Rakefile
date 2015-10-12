require 'bundler/gem_tasks'

task :default => [:build]

task :build do
  sh 'bundle install'
end

task :doc do
  sh 'yardoc'
end

task :test do
  sh 'rspec --init'
  sh 'rspec spec/ --fail-fast'
end

task :example do
  sh './examples/race_planning.rb'
end

task :clean do
  sh 'rm -rf pkg'
  sh 'rm -rf doc'
  sh 'rm -rf bin'
end
