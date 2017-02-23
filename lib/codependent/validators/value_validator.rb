module Codependent
  module Validators
    class ValueValidator
      SINGLETON_ERROR = 'Value injectables are only allowed on singletons.'.freeze
      NIL_VALUE_ERROR = 'Value injectables must not be nil.'.freeze
      NO_DEPENDENCIES_ERROR = 'Value injectables may not have dependencies'.freeze

      def call(type, state, dependencies)
        raise SINGLETON_ERROR unless type == :singleton
        raise NIL_VALUE_ERROR unless state[:value]

        no_dependencies = !dependencies || dependencies.count != 0

        raise NO_DEPENDENCIES_ERROR if no_dependencies
      end
    end
  end
end
