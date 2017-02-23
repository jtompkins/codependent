module Codependent
  module Validators
    class ConstructorInjectionValidator
      MISSING_TYPE_ERROR = 'Constructor injection requires a type to be specified.'.freeze
      MISSING_DEPENDENCY_KEYWORDS_ERROR = 'All dependencies must appear as keyword arguments to the constructor.'.freeze
      NO_ARGS_WITH_DEPENDENCIES_ERROR = 'Constructor injection requires the constructor to receive arguments.'.freeze

      def call(type, state, dependencies)
        unless state[:klass]
          raise MISSING_TYPE_ERROR
        end

        return unless dependencies.count > 0

        validate_constructor_params(state[:klass], dependencies)
      end

      private

      def validate_constructor_params(klass, dependencies)
        params = klass.instance_method(:initialize).parameters

        raise NO_ARGS_WITH_DEPENDENCIES_ERROR if params.count == 0

        return unless params.all? { |p| p[0] == :key || p[0] == :keyreq }

        dependency_keys = dependencies.map(&:to_s)
        parameter_keys = params.map { |p| p[1] }

        unless (dependency_keys - parameter_keys).empty?
          raise MISSING_DEPENDENCY_KEYWORDS_ERROR
        end
      end
    end
  end
end
