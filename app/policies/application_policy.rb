module ExampleSVC
  module Policies
    class ApplicationPolicy < ActionPolicy::Base
      pre_check :validate_context

      default_rule :manage?

      def manage?
        role?('admin')
      end

      private

      def role?(role)
        user.roles.include?(role)
      end

      def validate_context
        deny! unless user.is_a?(Structs::User)
      end
    end
  end
end
