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

    def instance(symbol, &block)
      raise ArgumentError, 'You must provide a block!' unless block

      injectables[symbol] = Codependent::Injectable.instance(block)
    end

    def singleton(symbol, value = nil, &block)
      unless block || value
        raise ArgumentError, 'You must provide a value or block'
      end

      injectables[symbol] = Codependent::Injectable.singleton(value, block)
    end

    def injectable?(symbol)
      injectables.key?(symbol)
    end

    def resolve(symbol)
      return unless injectable?(symbol)

      injectable = injectables[symbol]

      value = injectable.resolve

      injectable.dependencies.each { |dependency| inject!(value, dependency) }

      value
    end

    private

    attr_reader :injectables

    def to_setter(symbol)
      "#{symbol}=".to_sym
    end

    def inject!(value, dependency)
      return unless injectable?(dependency)

      value.send(to_setter(dependency), injectables[dependency].resolve)
    end
  end
end
