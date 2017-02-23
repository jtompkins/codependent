module Codependent
  module Resolvers
    class RecursiveResolver
      def initialize(injectables)
        @injectables = injectables
      end

      def call(id, resolved = {})
        return resolved[id] if resolved.key?(id)

        injectable = injectables[id]

        dependencies = injectable.dependencies.reduce({}) do |deps, dep_id|
          deps[dep_id] = call(dep_id, resolved)
        end

        resolved[id] = injectable.resolver.new.(injectable.state, dependencies)

        resolved[id]
      end

      private

      attr_reader :injectables
    end
  end
end
