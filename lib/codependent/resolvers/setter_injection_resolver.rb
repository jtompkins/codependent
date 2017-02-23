module Codependent
  module Resolvers
    class SetterInjectionResolver
      def call(state, dependency_hash)
        value = state[:klass].new

        dependency_hash.each { |dep_id, dep| value.send(to_setter(dep_id), dep) }

        value
      end

      private

      def to_setter(id)
        "#{id}=".to_sym
      end
    end
  end
end
