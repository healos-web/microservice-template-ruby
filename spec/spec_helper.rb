ENV['APP_ENV'] = 'test'

require 'karafka/testing/rspec/helpers'
require_relative '../config/application'

require "action_policy/rspec/dsl"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do
    DatabaseCleaner.clean
  end

  config.include Karafka::Testing::RSpec::Helpers
  config.include Dry::Monads[:result, :try, :list]
end

ExampleSVC::Application.finalize!

Factory = ROM::Factory.configure do |config|
  config.rom = ExampleSVC::Application['container']
end

Dir["#{File.dirname(__FILE__)}/support/factories/*.rb"].each { |file| require file }

require 'database_cleaner/sequel'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner[:sequel].db = ExampleSVC::Application['db.connection']
