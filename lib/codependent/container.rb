require_relative 'injectable'

module Codependent
  class Container
    def initialize(&block)
      @injectables = {}

      instance_eval(&block) if block
    end

    def instance(id, &config_block)
      validate_config_arguments(config_block)

      add_injectable!(id, :instance, config_block)
    end

    def singleton(id, &config_block)
      validate_config_arguments(config_block)

      add_injectable!(id, :singleton, config_block)
    end

    def injectable(id)
      injectables[id]
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

    def validate_config_arguments(config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end
    end

    def resolver
      Codependent::Resolver.new(injectables)
    end

    def add_injectable!(id, type, config_block)
      builder = Codependent::InjectableBuilder.new(type)

      builder.instance_eval(&config_block)

      injectables[id] = builder.injectable
    end
  end
end
