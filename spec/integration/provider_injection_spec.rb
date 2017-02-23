require 'spec_helper'
require 'codependent'

class ProviderLogger; end

class TestRepo
  def initialize(logger)
    @logger = logger
  end

  attr_reader :logger
end

describe 'Resolving dependencies with provider injection' do
  subject(:container) { Codependent::Container.new }

  before do
    container.singleton :logger do
      from_provider { ProviderLogger.new }
    end

    container.instance :repo do
      from_provider do |logger:|
        TestRepo.new(logger)
      end

      depends_on :logger
    end
  end

  describe 'resolving a simple dependency' do
    it 'returns a resolved value' do
      expect(container.resolve(:logger)).to be_a(ProviderLogger)
    end
  end

  describe 'resolving a nested dependency' do
    it 'returns a resolved value' do
      result = container.resolve(:repo)

      expect(result).to be_a(TestRepo)
      expect(result.logger).to be_a(ProviderLogger)
    end
  end
end
