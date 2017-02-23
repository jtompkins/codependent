require 'spec_helper'
require 'codependent'

describe Codependent::Resolvers::ProviderResolver do
  let(:block) { -> (_) { true } }
  let(:state) { { provider: block } }
  let(:dependencies) { { a_dependency: :a_value } }

  subject(:resolver) do
    Codependent::Resolvers::ProviderResolver.new
  end

  describe '#call' do
    it 'calls the block and passes dependencies' do
      expect(block).to receive(:call).with(**dependencies)

      resolver.(state, dependencies)
    end
  end
end
