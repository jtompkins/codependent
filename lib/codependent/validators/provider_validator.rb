module Codependent
  module Validators
    class ProviderValidator
      NO_BLOCK_ERROR = 'Provider injectables must have a block.'.freeze

      def call(_, state, _)
        raise NO_BLOCK_ERROR unless state[:provider]
      end
    end
  end
end
