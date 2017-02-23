require 'spec_helper'
require 'codependent'

describe Codependent::Resolvers::ValueResolver do
  let(:value) { :a_value }
  let(:state) { { value: value } }
  let(:dependencies) { {} }

  subject(:resolver) do
    Codependent::Resolvers::ValueResolver.new
  end

  describe '#call' do
    it 'returns the value from state' do
      expect(resolver.(state, dependencies)).to eq(value)
    end
  end
end
