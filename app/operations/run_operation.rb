module ExampleSVC
  module Operations
    class RunOperation < BaseOperation
      include Import['inflector']
      include Import['operations.authorize_operation']

      def call(params)
        operation_class = yield detect_operation(params[:operation])

        yield authorize_operation.call(operation_payload: params[:payload], operation_class:)

        result = yield run_operation(operation_class, params[:payload])

        Success(result)
      end

      private

      def detect_operation(operation)
        operation_const = inflector.camelize(operation)
        res = Try[NameError] { Operations::Requests.const_get(operation_const, false) }

        res.success? ? res : Failure(error: static['failure.uknown_operation'])
      end

      def run_operation(operation, payload)
        res = operation.new.call(payload[:params])

        res.success? ? res : Failure(extract_failure_payload(res))
      end

      def extract_failure_payload(result)
        case result
        when Failure(Dry::Validation::Result)
          result.failure.errors.to_h
        when Try::Error
          { error: result.exception.message }
        else
          result.failure
        end
      end
    end
  end
end
