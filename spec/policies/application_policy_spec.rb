require 'spec_helper'

RSpec.describe ExampleSVC::Policies::ApplicationPolicy do
  let(:context) { { user: } }
  let(:user) { { id: Faker::Internet.uuid, roles: } }
  let(:roles) { [] }

  describe_rule :manage? do
    failed "when user is not a User" do
      before { context[:user] = {} }
    end

    failed "when user roles is a User" do
      before { context[:user] = ExampleSVC::Structs::User.new(**user) }
    end

    succeed "when user has role `admin`" do
      before do
        roles.push('admin')
        context[:user] = ExampleSVC::Structs::User.new(**user)
      end
    end
  end
end
