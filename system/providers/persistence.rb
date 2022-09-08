module ExampleSVC
  Application.register_provider(:persistence) do
    start do
      config = target['db.config']

      config.auto_registration("#{target.root}/app/persistence", namespace: 'ExampleSVC::Persistence')

      register('container', ROM.container(config))
    end
  end
end
