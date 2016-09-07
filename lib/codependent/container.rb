require_relative 'injectable'

module Codependent
  class Container
    def initialize(&block)
      @injectables = {}

      instance_eval(&block) if block
    end

    def instance(config, &constructor)
      unless constructor
        raise ArgumentError, 'You must provide a constructor block.'
      end

      add_injectable!(config, Codependent::Injectable.instance(constructor))
    end

    def singleton(config, value = nil, &constructor)
      unless value || constructor
        raise ArgumentError, 'You must provide a value or constructor block.'
      end

      add_injectable!(
        config,
        Codependent::Injectable.singleton(value, constructor)
      )
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

    def parse_config(config)
      case config
      when Symbol
        [config, []]
      when Hash
        config.to_a.first
      end
    end

    def add_injectable!(config, injectable)
      id, dependencies = parse_config(config)

      injectable.depends_on(*dependencies) unless dependencies.empty?
      injectables[id] = injectable
    end
  end
end
