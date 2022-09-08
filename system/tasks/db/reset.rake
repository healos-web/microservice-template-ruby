desc 'Perform migration reset (full erase and migration up)'
task reset: :rom_configuration do
  ROM::SQL::RakeSupport.run_migrations(target: 0, allow_missing_migration_files: true)
  ROM::SQL::RakeSupport.run_migrations(allow_missing_migration_files: true)
  Rake::Task['db:seed'].execute
  puts '<= db:reset executed'

  Rake::Task['db:dump'].execute
end
