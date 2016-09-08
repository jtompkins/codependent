require_relative '../codependent'

module Codependent
  module Helper
    def instance(id, in_scope: :global, &config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end

      Codependent[in_scope].instance(id, &config_block)
    end

    def singleton(id, in_scope: :global, &config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end

      Codependent[in_scope].singleton(id, &config_block)
    end
  end
end
