require 'codependent/errors'

module Codependent
  module Validators
    class ValueValidator
      def call(type, state, dependencies)
        raise Codependent::Errors::ValueOnInstanceError unless type == :singleton
        raise Codependent::Errors::NoValueError unless state[:value]

        no_dependencies = !dependencies || dependencies.count != 0

        raise Codependent::Errors::ValueDependencyError if no_dependencies
      end
    end
  end
end
