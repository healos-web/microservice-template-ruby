require 'spec_helper'

RSpec.describe Utils::StaticParser do
  subject(:result) { described_class.call('spec/support/files/test_static.yml') }

  it 'parses yml file' do
    expect(result['test_deep']['deep_test']).to eq 'success'
  end

  it 'passes result through the ERB engine' do
    expect(result['test_erb']['erb_test']).to eq 'success'
  end
end
