require 'codependent/errors'

module Codependent
  module Validators
    class SetterInjectionValidator
      MISSING_ACCESSOR_KEYWORDS_ERROR = 'All dependencies must appear as accessors on the class.'.freeze

      def call(_, state, dependencies)
        raise Codependent::Errors::MissingTypeError unless state[:type]

        return unless dependencies.count > 0

        validate_setters(state[:type], dependencies)
      end

      private

      def validate_setters(klass, dependencies)
        dependencies.each do |dep_id|
          unless klass.method_defined? "#{dep_id}=".to_sym
            raise Codependent::Errors::MissingAccessorError
          end
        end
      end
    end
  end
end
