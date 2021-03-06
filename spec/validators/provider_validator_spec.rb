require 'spec_helper'
require 'codependent'

describe Codependent::Validators::ProviderValidator do
  let(:no_block_state) do
    {
      provider: nil
    }
  end

  let(:dependencies) { [:a_dependency] }

  subject(:validator) { Codependent::Validators::ProviderValidator.new }

  describe '#call' do
    it 'raises an exception if a block is not provided' do
      expect do
        validator.(:instance, no_block_state, dependencies)
      end.to raise_error(Codependent::Errors::MissingProviderBlockError)
    end
  end
end
