module Codependent
  module Resolvers
    class DeferredResolver
      def initialize(injectables)
        @injectables = injectables
      end

      attr_reader :injectables

      def resolve(id)
        graph = build_dependency_graph(id)

        dependencies = graph[:dependencies]
        deferred = graph[:deferred]

        resolved = build_initial_dependencies(dependencies)
        apply_deferred_values!(deferred, resolved)

        resolved[id]
      end

      private

      def deferred?(injectable)
        injectable.resolver == SetterInjectionResolver
      end

      def build_initial_dependencies(dependencies)
        dependencies.reduce({}) do |acc, id|
          acc.merge(id => resolve_value(id, acc))
        end
      end

      def apply_deferred_values!(deferred, available_dependencies)
        deferred.each do |id|
          injectable = injectables[id]
          resolver = injectable.resolver.new

          resolver.apply(
            available_dependencies[id],
            required_dependencies(available_dependencies, injectable)
          )
        end
      end

      def resolve_value(id, available_dependencies)
        injectable = injectables[id]
        dependencies = {}

        unless deferred?(injectable)
          dependencies = required_dependencies(
            available_dependencies,
            injectable
          )
        end

        injectable.value(dependencies)
      end

      def required_dependencies(all_dependencies, injectable)
        all_dependencies.select { |k, _| injectable.dependencies.include?(k) }
      end

      def build_dependency_graph(id)
        stack = [id]
        dependencies = [id]
        deferred = []

        until stack.empty?
          current_id = stack.pop
          current = injectables[current_id]

          deferred.unshift(current_id) if deferred?(current)

          current.dependencies.each do |dep_id|
            next if dependencies.include?(dep_id)
            dependencies.unshift(dep_id)
            stack.push(dep_id)
          end
        end

        { dependencies: dependencies, deferred: deferred }
      end
    end
  end
end
