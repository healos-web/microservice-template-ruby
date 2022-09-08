module ExampleSVC
  Application.register_provider(:core) do
    prepare do
      static_parser = Utils::StaticParser.call('system/static/responses.yml')
      static_fetcher = Utils::StaticFetcher.new(static_parser)

      register('static', static_fetcher)
      register('inflector', Application.config.inflector)
    end

    start do
      Dry::Validation.load_extensions(:monads)
    end
  end
end
