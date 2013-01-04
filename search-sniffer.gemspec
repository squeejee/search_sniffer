# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search-sniffer/version'

Gem::Specification.new do |gem|
  gem.name          = "search-sniffer"
  gem.version       = Search::Sniffer::VERSION
  gem.authors       = ["ATimofeev"]
  gem.email         = ["atimofeev@reactant.ru"]
  gem.description   = %q{Simple plugin to sniff inbound search terms from popular search engines}
  gem.summary       = %q{Squeejee search_sniffer plugin implementation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
