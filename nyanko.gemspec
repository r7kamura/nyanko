lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nyanko/version"

Gem::Specification.new do |gem|
  gem.name          = "nyanko"
  gem.version       = Nyanko::VERSION
  gem.authors       = ["Ryo Nakamura"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 3.0.10"
  gem.add_development_dependency "coffee-rails", ">= 3.0.10"
  gem.add_development_dependency "jquery-rails"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "rspec-rails", "2.12.2"
  gem.add_development_dependency "sass-rails", ">= 3.0.10"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "slim"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "uglifier"
end
