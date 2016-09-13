require 'codependent/injectable'

module Codependent
  class InjectableBuilder
    def initialize(type)
      @type = type
      @dependencies = []
    end

    attr_reader :constructor,
                :dependencies,
                :type,
                :value

    def with_constructor(&constructor)
      @constructor = constructor
    end

    def with_value(value)
      @value = value
    end

    def depends_on(*dependencies)
      @dependencies.concat(dependencies)
    end

    def injectable
      send("validate_#{type}")

      Injectable.new(@type, @dependencies, @value, @constructor)
    end

    private

    def validate_instance
      if constructor.nil?
        raise 'You must provide a constructor for an instance.'
      end
    end

    def validate_singleton
      if constructor.nil? && value.nil?
        raise 'You must provide a constructor or value for a singleton.'
      end
    end
  end
end
