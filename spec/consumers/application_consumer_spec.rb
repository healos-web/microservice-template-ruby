require 'spec_helper'

RSpec.describe ExampleSVC::Consumers::ApplicationConsumer do
  subject(:consumer) { karafka_consumer_for(:example_svc) }

  let(:run_operation) { instance_double(ExampleSVC::Operations::RunOperation) }
  let(:send_kafka_message) { instance_double(ExampleSVC::Operations::SendKafkaMessage) }

  let(:request_id) { 'test_request' }
  let(:headers) { { 'request_type' => 'some_type' } }

  let(:running_result) { Success({}) }
  let(:sending_result) { Success() }
  let(:payload) { { some: :value }.to_json }

  before do
    consumer.instance_variable_set(:@run_operation, run_operation)
    consumer.instance_variable_set(:@send_kafka_message, send_kafka_message)

    allow(run_operation).to receive(:call).and_return running_result
    allow(send_kafka_message).to receive(:call).and_return sending_result

    karafka_publish(payload, headers:, key: request_id)
  end

  describe '#consume' do
    it "calls RunOperation operation with correct params" do
      consumer.consume

      expect(run_operation).to have_received(:call).with(operation: headers['request_type'],
                                                         payload: JSON.parse(payload, symbolize_names: true))
    end

    context 'when operation result is Success' do
      let(:running_result) { Success(any: :success_response) }

      it 'sends success response to kafka' do
        consumer.consume

        expect(send_kafka_message).to have_received(:call).with(
          topic: 'api_requests', key: request_id, headers:,
          payload: { response_type: 'success', response_message: running_result.value! }
        )
      end
    end

    context 'when operation result is Failure' do
      let(:running_result) { Failure(any: :failure_response) }

      it 'sends success response to kafka' do
        consumer.consume

        expect(send_kafka_message).to have_received(:call).with(
          topic: 'api_requests', key: request_id, headers:,
          payload: { response_type: 'failure', response_message: running_result.failure }
        )
      end
    end

    context 'when sending is failed' do
      let(:sending_result) { Failure(error:) }
      let(:error) { 'Some error' }

      before { allow(ExampleSVC::KarafkaApp.logger).to receive(:error) }

      it 'logs error instead of raising' do
        expect { consumer.consume }.not_to raise_error

        expect(ExampleSVC::KarafkaApp.logger).to have_received(:error).with(error)
      end
    end
  end
end
