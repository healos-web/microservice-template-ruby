module ExampleSVC
  Application.register_provider(:db) do
    prepare do
      db_config = Utils::StaticParser.call('db/config.yml')[ENV.fetch('APP_ENV')]

      connection = Sequel.connect(db_config)

      register('db.connection', connection)
      register('db.config', ROM::Configuration.new(:sql, connection))
    end
  end
end
