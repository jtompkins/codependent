module Codependent
  module Validators
    class SetterInjectionValidator
      MISSING_TYPE_ERROR = 'Setter injection requires a type to be specified.'.freeze
      MISSING_ACCESSOR_KEYWORDS_ERROR = 'All dependencies must appear as accessors on the class.'.freeze

      def call(type, state, dependencies)
        unless state[:klass]
          raise MISSING_TYPE_ERROR
        end

        return unless dependencies.count > 0

        validate_setters(state[:klass], dependencies)
      end

      private

      def validate_setters(klass, dependencies)
        dependencies.each do |dep_id|
          unless klass.method_defined? "#{dep_id}=".to_sym
            raise MISSING_ACCESSOR_KEYWORDS_ERROR
          end
        end
      end
    end
  end
end
