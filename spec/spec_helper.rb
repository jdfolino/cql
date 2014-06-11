require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


require "#{File.dirname(__FILE__)}/../lib/cql"


RSpec.configure do |config|
  config.before(:all) do
    @feature_fixtures_directory = "#{File.dirname(__FILE__)}/../fixtures/features"
  end

  config.before(:each) do
    # Nothing yet
  end

  config.after(:each) do
    # Nothing yet
  end
end

