require 'pry'

module Codependent
  class Injectable
    def self.instance(block)
      Injectable.new(nil, block, false)
    end

    def self.singleton(value, block)
      Injectable.new(value, block, true)
    end

    attr_reader :dependencies

    def resolve
      return value if value

      if singleton?
        @value = block.call
      else
        block.call
      end
    end

    def depends_on(*args)
      dependencies.concat(args)

      self
    end

    private

    def initialize(value, block, singleton)
      @value = value
      @block = block
      @singleton = singleton
      @dependencies = []
    end

    attr_reader :value, :block

    def singleton?
      @singleton
    end
  end
end
