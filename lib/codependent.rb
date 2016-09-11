require 'codependent/container'
require 'codependent/injectable'
require 'codependent/injectable_builder'
require 'codependent/default_resolver'
require 'codependent/helper'

module Codependent
  class << self
    def clear
      @containers = nil
    end

    def reset(container_id)
      return unless container?(container_id)

      config_block = containers[container_id][:config]
      containers[container_id] = build(config_block)

      get_container(container_id)
    end

    def container?(container_id)
      containers.key?(container_id)
    end

    def container(container_id, &config_block)
      return self[container_id] if container?(container_id)

      containers[container_id] = build(config_block)

      get_container(container_id)
    end

    def [](container_id)
      get_container(container_id)
    end

    def global
      containers[:global]
    end

    private

    def build(config_block = nil)
      {
        container: Codependent::Container.new(&config_block),
        config: config_block
      }
    end

    def get_container(container_id)
      containers[container_id][:container]
    end

    def containers
      @containers ||= { global: build }
    end
  end
end
