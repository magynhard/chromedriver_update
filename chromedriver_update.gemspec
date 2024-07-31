# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chromedriver_update/version'

Gem::Specification.new do |spec|
  spec.name          = "chromedriver_update"
  spec.version       = ChromedriverUpdate::VERSION
  spec.executables   = %w[chromedriver_update]
  spec.authors       = ["Matthäus Beyrle"]
  spec.email         = ["chromedriver_update.gemspec@mail.magynhard.de"]

  spec.summary       = %q{Update an existing installation of chromedriver fitting to the current installed version of chrome}
  spec.homepage      = "https://github.com/magynhard/chromedriver_update"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'os', '~> 1.1.4'
  spec.add_dependency 'rubyzip', '~> 2.3.2'
  spec.add_dependency 'httparty', '~> 0.22.0'

  spec.add_development_dependency 'bundler',  '>= 1.14'
  spec.add_development_dependency 'rake',     '>= 10.0'
  spec.add_development_dependency 'rspec',    '>= 3.0'
end
