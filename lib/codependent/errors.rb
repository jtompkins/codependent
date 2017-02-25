module Codependent
  module Errors
    class CodependentError < StandardError; end

    class MissingTypeError < CodependentError
      def message
        'Type injection requires a type.'
      end
    end

    class MissingKeywordArgError < CodependentError
      def message
        'All dependencies must appear as keyword arguments.'
      end
    end

    class MissingAccessorError < CodependentError
      def message
        'All dependencies must have accessors.'
      end
    end

    class NoConstructorArgsError < CodependentError
      def message
        'No constructor arguments.'
      end
    end

    class MissingProviderBlockError < CodependentError
      def message
        'Providers must have a block.'
      end
    end

    class ValueDependencyError < CodependentError
      def message
        'Value injectables may not have dependencies.'
      end
    end

    class NoValueError < CodependentError
      def message
        'Value injectables must have a value.'
      end
    end

    class ValueOnInstanceError < CodependentError
      def message
        'Value injectables cannot be singletons.'
      end
    end
  end
end
