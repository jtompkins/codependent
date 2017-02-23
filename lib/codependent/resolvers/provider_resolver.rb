module Codependent
  module Resolvers
    class ProviderResolver
      def call(state, dependency_hash)
        state[:provider].call(dependency_hash)
      end
    end
  end
end
