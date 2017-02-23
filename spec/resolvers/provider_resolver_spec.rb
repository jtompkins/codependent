require 'codependent/resolvers/provider_resolver'

describe Codependent::Resolvers::ProviderResolver do
  let(:block) { -> (deps) { true } }

  let(:state) do
    {
      provider: block,
    }
  end

  let(:dependencies) do
    {
      a_dependency: :a_value
    }
  end

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
