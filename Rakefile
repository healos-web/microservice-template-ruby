require_relative 'config/application'
require 'rom-sql'
require 'rom/sql/rake_task'

Rake::Task["db:migrate"].clear
Rake::Task['db:clean'].clear
Rake::Task["db:reset"].clear

Dir.glob('system/tasks/data_migrations/*.rake').each { |r| import r }
Dir.glob('system/tasks/db/*.rake').each { |r| import r }

Rake.application.top_level_tasks.find { |task| task.start_with?('data_migrations') } &&
  ExampleSVC::Application.finalize!
