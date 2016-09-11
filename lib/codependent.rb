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

    def container?(container_id)
      containers.key?(container_id)
    end

    def container(container_id, &config_block)
      return self[container_id] if container?(container_id)

      containers[container_id] = Codependent::Container.new(&config_block)
    end

    def [](container_id)
      containers[container_id]
    end

    def global
      containers[:global]
    end

    private

    def containers
      @containers ||= { global: Codependent::Container.new }
    end
  end
end
