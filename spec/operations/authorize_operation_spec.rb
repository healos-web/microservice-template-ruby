require 'spec_helper'

module ExampleSVC
  module Operations
    module SomeRelations
      class SomeOperation < BaseOperation; end
    end
  end

  module Policies
    class SomeRelationPolicy < ApplicationPolicy; end
  end
end

RSpec.describe ExampleSVC::Operations::AuthorizeOperation do
  describe '#call' do
    subject(:authorize) { authorize_operation.call(operation_payload:, operation_class:) }

    let(:authorize_operation) { described_class.new }
    let(:operation_class) { ExampleSVC::Operations::SomeRelations::SomeOperation }
    let(:user) { { id: Faker::Internet.uuid } }
    let(:params) { { id: 'id', some: :params } }
    let(:operation_payload) { { user:, params: } }

    before { allow(authorize_operation).to receive(:allowed_to?).and_return(true) }

    context 'when User.new raises error' do
      before do
        allow(ExampleSVC::Structs::User).to receive(:new).and_raise(Dry::Struct::Error.new)
      end

      it 'returns failure' do
        expect(authorize).to be_failure
      end

      it 'does not call authorize' do
        authorize

        expect(authorize_operation).not_to have_received(:allowed_to?)
      end
    end

    it 'calls ActionPolicy allowed_to? with detected operation' do
      authorize

      expect(authorize_operation).to have_received(:allowed_to?)
        .with('some_operation?', ExampleSVC::Structs::PolicyRecord.new(relation: 'some_relations', id: params[:id]),
              context: { user: ExampleSVC::Structs::User.new(**user) },
              with: ExampleSVC::Policies::SomeRelationPolicy)
    end

    context 'when RelationPolicy not exists' do
      before do
        ExampleSVC::Policies.send(:remove_const, "SomeRelationPolicy")
      end

      it 'detects ApplicationPolicy' do
        authorize

        expect(authorize_operation).to have_received(:allowed_to?)
          .with('some_operation?', ExampleSVC::Structs::PolicyRecord.new(relation: 'some_relations', id: params[:id]),
                context: { user: ExampleSVC::Structs::User.new(**user) },
                with: ExampleSVC::Policies::ApplicationPolicy)
      end
    end

    context 'when allowed_to returns false' do
      before { allow(authorize_operation).to receive(:allowed_to?).and_return(false) }

      it 'returns failure' do
        expect(authorize).to be_failure
      end

      it 'returns error message' do
        expect(authorize.failure).to be_kind_of(Hash)
      end
    end

    context 'when allowed_to returns true' do
      it 'returns success monad' do
        expect(authorize).to be_success
      end
    end
  end
end
