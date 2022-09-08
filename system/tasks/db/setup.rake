namespace :db do
  desc 'Setup database'
  task :setup do
    logger = Logger.new($stdout)

    ExampleSVC::Application.start(:db)

    config = ExampleSVC::Application['db.config']
    config.gateways[:default].use_logger(logger)
  end
end
