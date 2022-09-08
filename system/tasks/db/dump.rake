DUMP_LOCATION = 'db/schema.sql'.freeze
PG_DUMP_COMMAND = "PGPASSWORD=#{ENV.fetch('DB_PASSWORD', nil)} " \
                  "pg_dump -U #{ENV.fetch('DB_USERNAME',
                                          nil)} -w -s examplesvc_#{ENV.fetch('APP_ENV')} > #{DUMP_LOCATION}".freeze

namespace :db do
  desc 'Dump database schema'
  task :dump do
    logger = Logger.new($stdout)

    unless ENV.fetch('APP_ENV') == 'development'
      logger.info 'Dumping schema for dev environment only'

      next
    end

    logger.info 'Dumping database schema...'

    system PG_DUMP_COMMAND

    logger.info 'Dumping database schema completed.'
  end
end
