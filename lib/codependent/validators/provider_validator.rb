require 'codependent/errors'

module Codependent
  module Validators
    class ProviderValidator
      def call(_, state, _)
        raise Codependent::Errors::MissingProviderBlockError unless state[:provider]
      end
    end
  end
end
