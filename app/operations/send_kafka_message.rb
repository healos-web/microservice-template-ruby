module ExampleSVC
  module Operations
    class SendKafkaMessage < BaseOperation
      def call(params)
        yield send_message(**params)

        Success()
      end

      private

      def send_message(topic:, headers: {}, payload: {}, key: SecureRandom.uuid)
        res = Try[Rdkafka::AbstractHandle::WaitTimeoutError] do
          Karafka.producer.produce_sync(topic:, key:, headers:, payload: payload.to_json)
        end

        res.success? ? res : Failure(error: static['logger.error.kafka_not_responding'])
      end
    end
  end
end
