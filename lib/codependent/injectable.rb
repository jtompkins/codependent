require 'pry'

module Codependent
  class Injectable
    def self.instance(block)
      Injectable.new(nil, block, false)
    end

    def self.singleton(value, block)
      Injectable.new(value, block, true)
    end

    def resolve
      return value if value

      if singleton?
        @value = block.call
      else
        block.call
      end
    end

    private

    def initialize(value, block, singleton)
      @value = value
      @block = block
      @singleton = singleton
    end

    attr_reader :value, :block

    def singleton?
      @singleton
    end
  end
end
