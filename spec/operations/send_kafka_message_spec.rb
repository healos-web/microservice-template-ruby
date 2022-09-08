require 'spec_helper'

RSpec.describe ExampleSVC::Operations::SendKafkaMessage do
  describe '#call' do
    subject(:send_kafka_message) { described_class.new.call(params) }

    let(:params) do
      {
        topic: 'test_topic',
        headers: { head: "test" },
        key:,
        payload:
      }
    end

    let(:key) { 'test_key' }
    let(:payload) { { some: :payload } }

    before { allow(Karafka.producer).to receive(:produce_sync) }

    it 'returns success monad' do
      expect(send_kafka_message).to be_success
    end

    it 'calls Karafka producer' do
      send_kafka_message

      expect(Karafka.producer).to have_received(:produce_sync).with(
        **params.except(:payload), payload: payload.to_json
      )
    end

    it 'can generate random key by default' do
      params.delete(:key)
      send_kafka_message

      expect(Karafka.producer).to have_received(:produce_sync).with(hash_including(key: kind_of(String)))
    end

    context 'when Karafka returns error Rdkafka::AbstractHandle::WaitTimeoutError' do
      before do
        allow(Karafka.producer).to receive(:produce_sync).and_raise(Rdkafka::AbstractHandle::WaitTimeoutError.new)
      end

      it 'returns failure monad' do
        expect(send_kafka_message).to be_failure
        expect(send_kafka_message.failure[:error]).to be_kind_of(String)
      end
    end
  end
end
