require 'codependent/resolvers/deferred_type_resolver'

module Codependent
  module Resolvers
    class RootResolver
      def initialize(injectables)
        @injectables = injectables
      end

      attr_reader :injectables

      def resolve(id)
        dependencies = build_dependency_graph(id)

        resolved = resolve_eager_dependencies(dependencies)
        resolve_deferred_dependencies!(resolved)

        resolved[id]
      end

      private

      def deferred?(injectable)
        injectable.resolver == DeferredTypeResolver
      end

      def resolve_eager_dependencies(injectable_ids)
        injectable_ids.reduce({}) do |acc, id|
          next acc if acc.key?(id)
          acc.tap { |hash| hash[id] = resolve_value(id, acc) }
        end
      end

      def resolve_deferred_dependencies!(available_dependencies)
        available_dependencies.keys.each do |id|
          injectable = injectables[id]

          next unless deferred?(injectable)

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

        until stack.empty?
          current = injectables[stack.pop]

          current.dependencies.each do |dep_id|
            stack.push(dep_id) unless dependencies.include?(dep_id)
            dependencies.unshift(dep_id)
          end
        end

        dependencies
      end
    end
  end
end
