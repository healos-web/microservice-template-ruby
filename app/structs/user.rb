module ExampleSVC
  module Structs
    class User < Dry::Struct
      attribute :id, ROM::SQL::Types::PG::UUID
      attribute :roles, Dry::Types['array'].default([].freeze)
    end
  end
end
