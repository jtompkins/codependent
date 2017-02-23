module Codependent
  module Resolvers
    class ValueResolver
      def call(state, dependency_hash)
        state[:value]
      end
    end
  end
end
