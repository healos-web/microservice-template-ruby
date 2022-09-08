namespace :db do
  # Переопределяем таску для миграций т.к. по умолчания Sequel требует наличие всех миграций в одной папке,
  # что невозможно с микросервисной архитектурой.
  # Sequel выдает ошибку `Sequel::Migrator::Error: Applied migration files not in file system`.
  desc 'Migrate the database (options [version_number])]'
  task :migrate, [:version] => :rom_configuration do |_, args|
    version = args[:version]

    if version.nil?
      ROM::SQL::RakeSupport.run_migrations(allow_missing_migration_files: true)
      puts '<= db:migrate executed'
    else
      ROM::SQL::RakeSupport.run_migrations(target: version.to_i, allow_missing_migration_files: true)
      puts "<= db:migrate version=[#{version}] executed"
    end

    Rake::Task['db:dump'].execute
  end
end
