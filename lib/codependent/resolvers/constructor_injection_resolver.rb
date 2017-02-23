module Codependent
  module Resolvers
    class ConstructorInjectionResolver
      def call(state, dependency_hash)
        constructor_args = dependency_hash.merge(state[:additional_args] || {})

        type = state[:type]

        if !constructor_args.empty?
          type.new(**constructor_args)
        else
          type.new
        end
      end
    end
  end
end
