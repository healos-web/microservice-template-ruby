module ExampleSVC
  module Structs
    class PolicyRecord < Dry::Struct
      attribute :id, ROM::SQL::Types::PG::UUID.optional
      attribute :relation, Dry::Types['string']
    end
  end
end
