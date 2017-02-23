module Codependent
  module Resolvers
    class ConstructorInjectionResolver
      def call(state, dependency_hash)
        constructor_args = dependency_hash.merge(state[:additional_args] || {})

        state[:type].new(**constructor_args)
      end
    end
  end
end
