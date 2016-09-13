require 'codependent/manager'

module Codependent
  module Helper
    def instance(id, in_container: :global, &config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end

      Codependent::Manager[in_container].instance(id, &config_block)
    end

    def singleton(id, in_container: :global, &config_block)
      unless config_block
        raise ArgumentError, 'You must provide a config block.'
      end

      Codependent::Manager[in_container].singleton(id, &config_block)
    end
  end
end
