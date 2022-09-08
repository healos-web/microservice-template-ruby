namespace :db do
  desc 'Perform migration down (removes all tables)'
  task clean: :rom_configuration do
    ROM::SQL::RakeSupport.run_migrations(target: 0, allow_missing_migration_files: true)
    puts '<= db:clean executed'

    Rake::Task['db:dump'].execute
  end
end
