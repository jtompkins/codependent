module Codependent
  class Injectable
    def initialize(type, dependencies, state, resolver)
      @type = type
      @dependencies = dependencies
      @state = state
      @resolver = resolver
      @singleton_value = nil
    end

    attr_reader :dependencies, :state, :resolver

    def depends_on?(dependency_id)
      @dependencies.include?(dependency_id)
    end

    def singleton?
      @type == :singleton
    end

    def instance?
      @type == :instance
    end

    def value(dependencies)
      singleton? ? singleton_value(dependencies) : instance_value(dependencies)
    end

    private

    def singleton_value(dependencies)
      @singleton_value ||= instance_value(dependencies)
    end

    def instance_value(dependencies)
      resolver.new.(state, dependencies)
    end
  end
end
