require "simplecov"
SimpleCov.start do
  add_filter "/spec\/fixtures/"
  add_filter "/spec\/dummy/"
end

ENV["RAILS_ENV"] ||= "test"
require "nyanko"

require File.expand_path("../dummy/config/environment", __FILE__)
require "rspec/rails"
require "rspec/autorun"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.after do
    Nyanko::Config.reset
    Nyanko::Config.units_directory_path = File.expand_path("../fixtures/units", __FILE__)
  end
end

Nyanko::Config.units_directory_path = File.expand_path("../fixtures/units", __FILE__)
