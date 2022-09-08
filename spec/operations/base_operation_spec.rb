require 'spec_helper'

class TestOperation < ExampleSVC::Operations::BaseOperation; end

RSpec.describe ExampleSVC::Operations::BaseOperation do
  describe '#call' do
    subject(:described_inst) { described_class.new.call({}) }

    it 'returns Failure' do
      expect(described_inst).to be_failure
    end
  end

  context "when class is inherited from #{described_class}" do
    subject(:operation_inst) { TestOperation.ancestors }

    it 'includes monads do by default' do
      expect(operation_inst).to include(Dry::Monads::Do)
    end

    it 'includes monads result by default' do
      expect(operation_inst).to include(Dry::Monads::Result::Mixin)
    end
  end
end
