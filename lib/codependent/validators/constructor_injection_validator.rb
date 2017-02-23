module Codependent
  module Validators
    class ConstructorInjectionValidator
      MISSING_TYPE_ERROR = 'Constructor injection requires a type to be specified.'.freeze
      MISSING_DEPENDENCY_KEYWORDS_ERROR = 'All dependencies must appear as keyword arguments to the constructor.'.freeze
      NO_ARGS_WITH_DEPENDENCIES_ERROR = 'Constructor injection requires the constructor to receive arguments.'.freeze

      def call(_, state, dependencies)
        raise MISSING_TYPE_ERROR unless state[:type]

        return unless dependencies.count > 0

        validate_constructor_params(state[:type], dependencies)
      end

      private

      def all_keywords?(params)
        params.all? { |p| p[0] == :key || p[0] == :keyreq }
      end

      def extract_param_names(params)
        params.map { |p| p[1] }
      end

      def params_for_all_dependencies?(dependencies, parameter_names)
        (dependencies - parameter_names).empty?
      end

      def validate_constructor_params(klass, dependencies)
        params = klass.instance_method(:initialize).parameters

        raise NO_ARGS_WITH_DEPENDENCIES_ERROR if params.count == 0

        return unless all_keywords?(params)

        parameter_names = extract_param_names(params)

        return if params_for_all_dependencies?(dependencies, parameter_names)

        raise MISSING_DEPENDENCY_KEYWORDS_ERROR
      end
    end
  end
end
