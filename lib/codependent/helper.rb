require_relative '../codependent'

module Codependent
  module Helper
    def instance(id, &constructor)
      constructor ||= -> { new }

      @codependent_injectable = Codependent[scope].instance(id, &constructor)
    end

    def singleton(id, value = nil, &constructor)
      @codependent_injectable =
        if value
          Codependent[scope].singleton(id, value)
        else
          constructor ||= -> { new }

          Codependent[scope].singleton(id, &constructor)
        end
    end

    def scope
      @codependent_scope || :global
    end

    def in_scope(scope_id)
      @codependent_scope = scope_id
    end

    def depends_on(*dependency_ids)
      unless @codependent_injectable
        raise 'You must define the injectable first.'
      end

      @codependent_injectable.depends_on(*dependency_ids)
    end
  end
end
