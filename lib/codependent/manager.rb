require 'codependent/container'

module Codependent
  class Manager
    class << self
      @instance = nil

      def instance
        @instance ||= Manager.new
      end

      def reset!
        @instance = nil
      end

      def method_missing(method, *args, &block)
        super unless instance.respond_to?(method)

        @instance.send(method, *args, &block)
      end
    end

    def container?(container_id)
      containers.key?(container_id)
    end

    def reset_container!(container_id)
      return unless container?(container_id)

      config_block = containers[container_id][:config]
      containers[container_id] = build_container(config_block)

      get_container(container_id)
    end

    def container(container_id, &config_block)
      unless container?(container_id)
        containers[container_id] = build_container(config_block)
      end

      get_container(container_id)
    end

    def [](container_id)
      get_container(container_id)
    end

    def global
      get_container(:global)
    end

    private

    def build_container(config_block = nil)
      {
        container: Codependent::Container.new(&config_block),
        config: config_block
      }
    end

    def get_container(container_id)
      containers[container_id][:container]
    end

    def containers
      @containers ||= { global: build_container }
    end
  end
end
