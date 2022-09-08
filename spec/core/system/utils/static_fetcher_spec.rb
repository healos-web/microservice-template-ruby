require 'spec_helper'

RSpec.describe Utils::StaticFetcher do
  subject(:fetcher) { described_class.new(hash) }

  let(:hash) do
    {
      'test' => { 'success' => '1' },
      'test_gsub' => 'success %{test} and %{test}'
    }
  end

  context 'when value exists' do
    it 'returns value by key' do
      expect(fetcher['test.success']).to eq hash['test']['success']
    end

    it 'gsubs provided values' do
      expect(fetcher['test_gsub', test: 'a']).to eq 'success a and a'
    end
  end

  context 'when value does not exist' do
    it 'returns nil' do
      expect(fetcher['test2']).to be_nil
    end
  end
end
