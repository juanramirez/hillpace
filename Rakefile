require 'bundler/gem_tasks'

task :default => [:build]

task :build do
  sh 'bundle install'
end

task :test do
  sh 'rspec spec/ --fail-fast'
end

task :example do
  sh './example.rb'
end
