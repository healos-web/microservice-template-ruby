ENV["APP_ENV"] ||= "development"

require "bundler"
Bundler.require(:default, ENV.fetch('APP_ENV'))

require_relative '../system/utils/static_parser'
require_relative '../system/utils/static_fetcher'

Dotenv.load(".env", ".env.#{ENV.fetch('APP_ENV')}")
