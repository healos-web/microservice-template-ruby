require 'spec_helper'

RSpec.describe ExampleSVC::Application do
  it 'provides access to the ROM container' do
    expect(described_class['container']).to be_kind_of(ROM::Container)
  end

  it 'provides access to the db config' do
    expect(described_class['db.config']).to be_kind_of(ROM::Configuration)
  end

  it 'provides access to the db connection' do
    expect(described_class['static']).to be_kind_of(Utils::StaticFetcher)
  end
end
