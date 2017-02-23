require 'codependent/injectable'
require 'codependent/resolvers/recursive_resolver'

module Codependent
  class Container
    def initialize(&block)
      @injectables = {}
      @singleton_values = {}

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

      injectable = injectable(id)

      if injectable.singleton?
        resolve_singleton(id)
      else
        resolver.(id)
      end
    end

    private

    attr_reader :injectables, :singleton_values

    def resolver(id)
      injectables(id).resolver
    end

    def resolve_dependency(id)
      resolver = resolver(id).new(injectables)
      resolver.(id)
    end

    def resolve_singleton(id)
      return singleton_values[id] if singleton_values.key?(id)

      singleton_values[id] = resolver.(id)

      singleton_values[id]
    end

    def validate_config_arguments(config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end
    end

    def add_injectable!(id, type, config_block)
      builder = Codependent::InjectableBuilder.new(type)

      builder.instance_eval(&config_block)

      injectables[id] = builder.build
    end
  end
end
