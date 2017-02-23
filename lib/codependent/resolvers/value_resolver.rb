module Codependent
  module Resolvers
    class ValueResolver
      def call(state, _)
        state[:value]
      end
    end
  end
end
