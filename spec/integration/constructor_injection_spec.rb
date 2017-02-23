require 'spec_helper'
require 'codependent'

class ConstructorLogger; end

class ConstructorRepo
  def initialize(logger:)
    @logger = logger
  end

  attr_reader :logger
end

describe 'Resolving dependencies with constructor injection' do
  subject(:container) { Codependent::Container.new }

  before do
    container.singleton :logger do
      from_type ConstructorLogger
    end

    container.instance :repo do
      from_type ConstructorRepo
      depends_on :logger
    end
  end

  describe 'resolving a simple dependency' do
    it 'returns a resolved value' do
      expect(container.resolve(:logger)).to be_a(ConstructorLogger)
    end
  end

  describe 'resolving a nested dependency' do
    it 'returns a resolved value' do
      result = container.resolve(:repo)

      expect(result).to be_a(ConstructorRepo)
      expect(result.logger).to be_a(ConstructorLogger)
    end
  end
end
