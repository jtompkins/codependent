module Codependent
  module Validators
    class ProviderValidator
      NO_BLOCK_ERROR = 'Provider injectables must have a block.'.freeze

      def call(type, state, dependencies)
        unless state[:provider]
          raise NO_BLOCK_ERROR
        end
      end
    end
  end
end
