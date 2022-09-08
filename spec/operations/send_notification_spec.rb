require 'spec_helper'

RSpec.describe ExampleSVC::Operations::SendNotification do
  describe '#call' do
    subject(:send_notification) do
      described_class.new(send_kafka_message:).call(params)
    end

    let(:params) do
      { some: :info, room_id: :id, and: :other }
    end

    let(:send_kafka_message) { instance_double(ExampleSVC::Operations::SendKafkaMessage) }

    before do
      allow(send_kafka_message).to receive(:call).and_return(Success())
    end

    it 'returns success monad' do
      expect(send_notification).to be_success
    end

    it 'calls send_kafka_message operation' do
      send_notification

      expect(send_kafka_message).to have_received(:call)
        .with(topic: 'notifications_svc', headers: { request_type: 'notifications/create' }, payload: { params: })
    end

    context 'when send kafka message operation failed' do
      before do
        allow(send_kafka_message).to receive(:call).and_return(Failure())
      end

      it 'returns failure monad' do
        expect(send_notification).to be_failure
      end
    end
  end
end
