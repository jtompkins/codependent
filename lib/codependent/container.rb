require_relative 'injectable'

module Codependent
  class Container
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
