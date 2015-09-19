# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hillpace/version'

Gem::Specification.new do |spec|
  spec.name          = "hillpace"
  spec.version       = Hillpace::VERSION
  spec.authors       = ["Juan Ramírez Ruiz"]
  spec.email         = ["juan.ramirez.ruiz@gmail.com"]
  spec.summary       = 'Estimate running paces depending on climb grade'
  spec.description   = <<-EOF
    Hillpace is a gem for running races planning. It can take a route an a reference pace (the pace you would go on a
    flat course of the same distance) and generate planned paces by segments, based on the incline of each segment.
  EOF
  spec.homepage      = "https://github.com/juanramirez/hillpace"
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*.rb", "resources/*", "bin/*", "LICENSE", "*.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~>1.7"
  spec.add_development_dependency "rake", "~>10.0"
  spec.add_development_dependency "rspec", "~>3.3"
  spec.add_development_dependency "nokogiri", "~>1.6"
  spec.add_development_dependency "zip", "~>2.0"
  spec.add_development_dependency "geokit", "~>1.10"
  spec.add_development_dependency "geoelevation", "~>0.0", ">= 0.0.1"
end
