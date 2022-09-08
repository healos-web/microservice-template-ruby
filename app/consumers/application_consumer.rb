module ExampleSVC
  module Consumers
    class ApplicationConsumer < Karafka::BaseConsumer
      include Dry::Monads[:result]
      include Import['operations.run_operation']
      include Import['operations.send_kafka_message']

      # Мы могли бы обрабатывать сообщения асинхронно, однако это нецелесообразно
      # так как поднять несколько микросервисов документов проще и не ожидается большого количества сообщений.
      def consume
        messages.each do |message|
          result = run_operation.call(
            operation: message.headers['request_type'],
            payload: JSON.parse(message.raw_payload, symbolize_names: true)
          )

          handle_result(message, result)
        end
      end

      private

      def handle_result(request_message, result)
        response_payload = case result.to_result
                           when Success
                             build_response_payload('success', result.value!)
                           when Failure
                             build_response_payload('failure', result.failure)
                           end

        send_response(request_message, response_payload)
      end

      def build_response_payload(type, message)
        {
          response_type: type,
          response_message: message
        }
      end

      def send_response(request_message, payload)
        sending_result = send_kafka_message.call(
          {
            topic: 'api_requests',
            key: request_message.key,
            headers: request_message.headers,
            payload:
          }
        ).to_result

        KarafkaApp.logger.error(sending_result.failure[:error]) unless sending_result.success?

        sending_result
      end
    end
  end
end
