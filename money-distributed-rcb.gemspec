# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'money/distributed/fetcher/russian_central_bank/version'

Gem::Specification.new do |spec|
  spec.name          = 'money-distributed-rcb'
  spec.version       = Money::Distributed::Fetcher::RussianCentralBank::VERSION
  spec.authors       = ['DarthSim']
  spec.email         = ['darthsim@gmail.com']

  spec.summary       = 'Russian Central Bank fetcher for money-distributed gem'
  spec.homepage      = 'https://github.com/DarthSim/money-distributed-rcb'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop', '~> 0.44.1'
  # travis installs rack uncompatible with ruby < 2.2.2
  spec.add_development_dependency 'rack', '1.6.4'

  spec.add_dependency 'money-distributed', '>= 0.0.2.2'
  spec.add_dependency 'savon'
end
