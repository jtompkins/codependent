require 'codependent/container'
require 'codependent/injectable'
require 'pry'

module Codependent
  module Helper
    def instance(id, &block)
      constructor = block || -> { new }

      @injectable = Codependent::Container[scope].instance(id, &constructor)
    end

    def singleton(id, value = nil, &block)
      if value
        @injectable = Codependent::Container[scope].singleton(id, value)
      else
        constructor = block || -> { new }
        @injectable = Codependent::Container[scope].singleton(id, &constructor)
      end
    end

    def in_scope(scope_id)
      @scope = scope_id
    end

    def depends_on(*dependency_ids)
      unless injectable
        raise ArgumentError, 'You must define the injectable first.'
      end

      injectable.depends_on(*dependency_ids)
    end

    private

    attr_reader :injectable

    def scope
      @scope || :global
    end
  end
end
