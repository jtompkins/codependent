require 'spec_helper'
require 'codependent'

describe 'Resolving dependencies with value injection' do
  subject(:container) { Codependent::Container.new }

  before do
    container.singleton :logger do
      from_value :a_logger
    end
  end

  describe 'resolving a simple dependency' do
    it 'returns a resolved value' do
      expect(container.resolve(:logger)).to eq(:a_logger)
    end
  end
end
