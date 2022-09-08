require 'spec_helper'

module ExampleSVC
  module Operations
    module Requests
      class TestOperation < BaseOperation; end
    end
  end

  module Contracts
    class TestContract < Dry::Validation::Contract
      params do
        required(:test).filled(:string)
      end
    end
  end
end

RSpec.describe ExampleSVC::Operations::RunOperation do
  describe '#call' do
    subject(:run_operation) { described_class.new(authorize_operation:).call(params) }

    let(:params) { { operation:, payload: } }
    let(:operation) { 'test_operation' }
    let(:payload) { { params: { some: :params } } }
    let(:user) { { id: 'test' } }
    let(:authorize_operation) { instance_double(ExampleSVC::Operations::AuthorizeOperation) }

    context 'when operation does not exist' do
      let(:operation) { 'unknown_operation' }

      it 'returns failure' do
        expect(run_operation).to be_failure
      end

      it 'returns error message' do
        expect(run_operation.failure).to be_kind_of(Hash)
      end
    end

    context 'when operation exists' do
      let(:operation) { 'test_operation' }
      let(:payload) { { params: :payload, user: } }
      let(:test_operation) { instance_double(ExampleSVC::Operations::Requests::TestOperation) }
      let(:result) { Success(test_operation) }

      before do
        allow(ExampleSVC::Operations::Requests::TestOperation).to receive(:new).and_return(test_operation)
        allow(authorize_operation).to receive(:call).and_return(Success())
        allow(test_operation).to receive(:call).and_return(result)
      end

      it 'calls authorize operation' do
        run_operation

        expect(authorize_operation).to have_received(:call)
          .with(operation_payload: payload,
                operation_class: ExampleSVC::Operations::Requests::TestOperation)
      end

      context 'when access denied' do
        before do
          allow(authorize_operation).to receive(:call).and_return(Failure())
        end

        it 'returns failure' do
          expect(run_operation).to be_failure
        end
      end

      context 'when authorized successfully' do
        it 'calls detected operation' do
          run_operation

          expect(test_operation).to have_received(:call).with(payload[:params])
        end

        context 'when test operation returns success' do
          let(:result) { Success() }

          it 'returns success' do
            expect(run_operation).to be_success
          end
        end

        context 'when test operation fails and failure is an instance of Dry::Validation::Result' do
          let(:result) { ExampleSVC::Contracts::TestContract.new.call({}).to_monad }

          it 'returns failure' do
            expect(run_operation).to be_failure
          end

          it 'returns error message' do
            expect(run_operation.failure).to be_kind_of(Hash)
          end
        end

        context 'when test operation fails when failure is an instance of StandardError' do
          let(:result) { Try { raise 'error' } }

          it 'returns failure' do
            expect(run_operation).to be_failure
          end

          it 'returns error message' do
            expect(run_operation.failure).to be_kind_of(Hash)
          end
        end

        context 'when test operation fails when failure is an instance of Hash' do
          let(:result) { Failure({}) }

          it 'returns failure' do
            expect(run_operation).to be_failure
          end

          it 'returns error message' do
            expect(run_operation.failure).to be_kind_of(Hash)
          end
        end
      end
    end
  end
end
