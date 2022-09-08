source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"

group :development, :test do
  gem 'faker'
  gem 'pry', '~> 0.13.1'
  gem 'rom-factory'
end

group :development do
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :test do
  gem 'database_cleaner-sequel'
  gem 'karafka-testing'
  gem 'rspec', require: false
end

gem "action_policy", "~> 0.6.0"

gem 'dotenv'
gem 'dry-monads', require: [
  "dry/monads",
  "dry/monads/do"
]
gem 'dry-system', require: [
  'dry/system/container',
  'dry/system/loader/autoloading'
]

gem 'karafka', '~> 2.0.0.alpha6'

gem 'pg'

gem 'rom'
gem 'rom-sql'
