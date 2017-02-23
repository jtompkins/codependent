module Codependent
  class Injectable
    def initialize(type, dependencies, state, resolver)
      @type = type
      @dependencies = dependencies
      @state = state
      @resolver = resolver
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
      resolver.new.(state, dependencies)
    end
  end
end
