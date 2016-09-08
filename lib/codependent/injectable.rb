module Codependent
  class Injectable
    def initialize(type, dependencies, value = nil, constructor = nil)
      @type = type
      @dependencies = dependencies
      @value = value
      @constructor = constructor
    end

    def depends_on?(dependency_id)
      @dependencies.include?(dependency_id)
    end

    def singleton?
      @type == :singleton
    end

    def instance?
      @type == :instance
    end

    def value
      return @value if @value

      if singleton?
        @value = @constructor.call
      else
        @constructor.call
      end
    end
  end
end
