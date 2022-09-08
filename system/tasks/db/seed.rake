namespace :db do
  desc 'Populate database with default values'
  task :seed do
    return if ENV.fetch('APP_ENV') == 'test'

    Rake::Task['data_migrations:create_duty_roles'].execute
  end
end
