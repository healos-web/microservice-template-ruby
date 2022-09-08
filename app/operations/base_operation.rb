module ExampleSVC
  module Operations
    class BaseOperation
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do
      include Import["static"]

      def call(_params)
        Failure(error: static['failure.uknown_operation'])
      end
    end
  end
end
