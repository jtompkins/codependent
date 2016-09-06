module Codependent
  class DefaultResolver
    def initialize(injectables)
      @injectables = injectables
    end

    attr_reader :injectables

    def resolve(id)
      resolve_dependency(id)
    end

    private

    def to_setter(id)
      "#{id}=".to_sym
    end

    def resolve_dependency(id, resolved = {})
      return resolved[id] if resolved.key?(id)

      injectable = injectables[id]
      resolved[id] = injectable.value

      injectable.dependencies.each do |dep_id|
        setter = to_setter(dep_id)
        dependency = resolve_dependency(dep_id, resolved)

        resolved[id].send(setter, dependency)
      end

      resolved[id]
    end
  end
end
