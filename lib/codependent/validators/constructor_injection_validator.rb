require 'codependent/errors'

module Codependent
  module Validators
    class ConstructorInjectionValidator
      def call(_, state, dependencies)
        raise Codependent::Errors::MissingTypeError unless state[:type]

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

        raise Codependent::Errors::NoConstructorArgsError if params.count == 0

        return unless all_keywords?(params)

        parameter_names = extract_param_names(params)

        return if params_for_all_dependencies?(dependencies, parameter_names)

        raise Codependent::Errors::MissingKeywordArgError
      end
    end
  end
end
