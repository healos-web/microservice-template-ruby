module ExampleSVC
  module Operations
    class AuthorizeOperation < BaseOperation
      include ActionPolicy::Behaviour
      include Import['inflector']

      def call(operation_payload:, operation_class:)
        @operation_class = operation_class

        user = yield build_user(operation_payload[:user])

        if authorize(user, operation_payload[:params])
          Success()
        else
          Failure(error: static['failure.unauthorized'])
        end
      end

      private

      def authorize(user, params)
        allowed_to?(
          authorize_operation,
          Structs::PolicyRecord.new(relation: authorize_relation, id: params[:id]),
          context: { user: },
          with: authorize_policy
        )
      end

      def authorize_policy
        Policies.const_get("#{inflector.singularize(authorize_namespace)}Policy", false)
      rescue NameError
        Policies::ApplicationPolicy
      end

      def authorize_relation
        inflector.underscore(authorize_namespace)
      end

      def authorize_operation
        "#{inflector.underscore(inflector.demodulize(@operation_class))}?"
      end

      def authorize_namespace
        @authorize_namespace = @operation_class.to_s.split("::")[-2]
      end

      def build_user(user_hash)
        Success(Structs::User.new(**user_hash))
      rescue Dry::Struct::Error
        Failure(error: static['failure.current_user_error'])
      end
    end
  end
end
