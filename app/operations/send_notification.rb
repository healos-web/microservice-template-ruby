module ExampleSVC
  module Operations
    class SendNotification < BaseOperation
      include Import['send_kafka_message']

      def call(params)
        result = yield send_kafka_message.call(
          topic: 'notifications_svc',
          headers:,
          payload: { params: }
        )

        Success(result)
      end

      private

      def headers
        { request_type: 'notifications/create' }
      end
    end
  end
end
