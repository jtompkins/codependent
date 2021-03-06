require 'spec_helper'
require 'codependent'

class SetterLogger; end

class SetterRepo
  attr_accessor :logger
end

class CircularRepoA
  attr_accessor :circular_repo_b
end

class CircularRepoB
  attr_accessor :circular_repo_a
end

describe 'Resolving dependencies with constructor injection' do
  subject(:container) { Codependent::Container.new }

  before do
    container.singleton :logger do
      from_type SetterLogger
      inject_setters
    end

    container.instance :repo do
      from_type SetterRepo
      inject_setters
      depends_on :logger
    end
  end

  describe 'resolving a simple dependency' do
    it 'returns a resolved value' do
      expect(container.resolve(:logger)).to be_a(SetterLogger)
    end
  end

  describe 'resolving a nested dependency' do
    it 'returns a resolved value' do
      result = container.resolve(:repo)

      expect(result).to be_a(SetterRepo)
      expect(result.logger).to be_a(SetterLogger)
    end
  end

  describe 'resolving a circular dependency' do
    before do
      container.instance :circular_repo_a do
        from_type CircularRepoA
        inject_setters
        depends_on :circular_repo_b
      end

      container.instance :circular_repo_b do
        from_type CircularRepoB
        inject_setters
        depends_on :circular_repo_a
      end
    end

    it 'returns a resolved value' do
      result = container.resolve(:circular_repo_a)

      expect(result).to be_a(CircularRepoA)
      expect(result.circular_repo_b).to be_a(CircularRepoB)
      expect(result.circular_repo_b.circular_repo_a).to eq(result)
    end
  end
end
