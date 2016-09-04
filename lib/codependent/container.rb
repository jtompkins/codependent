require_relative 'injectable'

module Codependent
  class Container
    class << self
      def reset_scopes
        @scopes = {
          global: Container.new
        }
      end

      def add_scope(scope, container = Container.new)
        reset_scopes unless scopes

        return scopes[scope] if scopes.key?(scope)

        scopes[scope] = container
      end

      def [](scope)
        return unless scopes.key?(scope)

        scopes[scope]
      end

      def method_missing(method)
        self[method]
      end

      private

      attr_reader :scopes
    end

    def initialize
      @injectables = {}
    end

    def instance(id, &constructor)
      unless constructor
        raise ArgumentError, 'You must provide a constructor block.'
      end

      injectables[id] = Codependent::Injectable.instance(constructor)
    end

    def singleton(id, value = nil, &constructor)
      unless value || constructor
        raise ArgumentError, 'You must provide a value or constructor block.'
      end

      injectables[id] = Codependent::Injectable.singleton(value, constructor)
    end

    def injectable?(id)
      injectables.key?(id)
    end

    def resolve(id, resolved = {})
      return unless injectable?(id)
      return resolved[id] if resolved.key?(id)

      injectable = injectables[id]
      resolved[id] = injectable.value

      injectable.dependencies.each do |dep_id|
        resolved[id].send(to_setter(dep_id), resolve(dep_id, resolved))
      end

      resolved[id]
    end

    private

    attr_reader :injectables

    def to_setter(id)
      "#{id}=".to_sym
    end
  end
end
