require_relative 'injectable'

module Codependent
  class Container
    def initialize
      @registrations = {}
    end

    def register(symbol, &block)
      raise ArgumentError, 'You must provide a block!' unless block

      @registrations[symbol] = Codependent::Injectable.instance(block)
    end

    def register_singleton(symbol, value = nil, &block)
      unless block || value
        raise ArgumentError, 'You must provide a value or block'
      end

      @registrations[symbol] = Codependent::Injectable.singleton(value, block)
    end

    def registered?(symbol)
      @registrations.key?(symbol)
    end

    def resolve(symbol)
      return nil unless @registrations.key?(symbol)

      @registrations[symbol].resolve
    end
  end
end
