module Codependent
  module Validators
    class ValueValidator
      SINGLETON_ERROR = 'Value injectables are only allowed on singletons.'.freeze
      NIL_VALUE_ERROR = 'Value injectables must not be nil.'.freeze
      NO_DEPENDENCIES_ERROR = 'Value injectables may not have dependencies'.freeze

      def call(type, state, dependencies)
        unless type == :singleton
          raise SINGLETON_ERROR
        end

        unless state[:value]
          raise NIL_VALUE_ERROR
        end

        if !dependencies || dependencies.count != 0
          raise NO_DEPENDENCIES_ERROR
        end
      end
    end
  end
end
