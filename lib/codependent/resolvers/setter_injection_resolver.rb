module Codependent
  module Resolvers
    class SetterInjectionResolver
      def call(state, _)
        state[:type].new
      end

      def apply(value, dependencies)
        dependencies.each do |dep_id, dep|
          value.send(to_setter(dep_id), dep)
        end
      end

      private

      def to_setter(id)
        "#{id}=".to_sym
      end
    end
  end
end
