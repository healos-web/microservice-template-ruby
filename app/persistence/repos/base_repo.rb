module ExampleSVC
  module Persistence
    module Repos
      class BaseRepo < ROM::Repository::Root
        include Import["container"]

        struct_namespace Entities
      end
    end
  end
end
