require_relative "boot"

module ExampleSVC
  class Application < Dry::System::Container
    use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
    use :zeitwerk
    use :logging

    configure do |config|
      config.root = File.expand_path('..', __dir__)

      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym('SVC')
      end

      config.component_dirs.add 'app' do |dir|
        dir.namespaces.add_root(const: 'example_svc')
        dir.namespaces.add 'persistence', key: nil, const: 'example_svc/persistence'
      end
    end
  end

  Import = ExampleSVC::Application.injector
  ENV['KARAFKA_ENV'] ||= ENV.fetch('APP_ENV')

  class KarafkaApp < Karafka::App
    setup do |config|
      config.kafka = { 'bootstrap.servers': ENV.fetch('KAFKA_URL', '127.0.0.1:9092') }
      config.client_id = 'example_svc'

      config.concurrency = 2
      config.max_wait_time = 500 # 0.5 second
      config.consumer_persistence = ENV.fetch('APP_ENV') != 'development'
    end

    Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)

    routes.draw do
      consumer_group 'api' do
        topic 'example_svc' do
          consumer Consumers::ApplicationConsumer
        end
      end
    end
  end
end
