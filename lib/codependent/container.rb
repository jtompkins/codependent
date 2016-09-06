require_relative 'injectable'

module Codependent
  class Container
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

      resolver.resolve(id)
    end

    private

    attr_reader :injectables

    def resolver
      Codependent::DefaultResolver.new(injectables)
    end
  end
end
