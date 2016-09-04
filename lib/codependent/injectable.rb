module Codependent
  class Injectable
    def self.instance(constructor)
      Injectable.new(nil, constructor, false)
    end

    def self.singleton(value, constructor)
      Injectable.new(value, constructor, true)
    end

    attr_reader :dependencies

    def value
      return @value if @value

      if singleton?
        @value = @constructor.call
      else
        @constructor.call
      end
    end

    def depends_on(*dependency_ids)
      dependencies.concat(dependency_ids)
    end

    private

    def initialize(value, constructor, singleton)
      @value = value
      @constructor = constructor
      @singleton = singleton
      @dependencies = []
    end

    def singleton?
      @singleton
    end
  end
end
