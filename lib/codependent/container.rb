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

      def method_missing(method)
        return unless scopes.key?(method)

        scopes[method]
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

    def resolve(id)
      return unless injectable?(id)

      injectable = injectables[id]
      value = injectable.value

      injectable.dependencies.each do |dependency_id|
        value.send(to_setter(dependency_id), resolve(dependency_id))
      end

      value
    end

    private

    attr_reader :injectables

    def to_setter(id)
      "#{id}=".to_sym
    end
  end
end
