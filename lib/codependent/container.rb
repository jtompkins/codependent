require 'codependent/injectable'
require 'codependent/resolvers/root_resolver'

module Codependent
  class Container
    CONFIG_BLOCK_MISSING_ERROR = 'You must provide a config block.'.freeze

    def initialize(args = {}, &block)
      @injectables = {}

      instance_exec(args, &block) if block
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

    attr_reader :injectables, :singleton_values

    def resolver
      Resolvers::RootResolver.new(injectables)
    end

    def validate_config_arguments(config_block)
      raise ArgumentError, CONFIG_BLOCK_MISSING_ERROR unless config_block
    end

    def add_injectable!(id, type, config_block)
      builder = Codependent::InjectableBuilder.new(id, type)

      builder.instance_eval(&config_block)

      injectables[id] = builder.build
    end
  end
end
