require 'spec_helper'
require 'codependent'

class TestLogger; end

class SimpleRepo
  def initialize(logger:)
    @logger = logger
  end

  attr_reader :logger
end

class NestedRepo
  attr_accessor :simple_repo
end

class ProvidedRepo
  def initialize(nested_repo)
    @nested_repo = nested_repo
  end

  attr_reader :nested_repo
end

class InjectableA; attr_accessor :injectable_b; end

class InjectableB
  def initialize(injectable_c:)
    @injectable_c = injectable_c
  end
  attr_reader :injectable_c
end

class InjectableC; attr_accessor :injectable_a; end

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe 'resolving a deeply-nested singleton' do
    before do
      container.singleton :logger do
        from_value Object.new
      end

      container.instance :simple_repo do
        from_type SimpleRepo
        depends_on :logger
      end

      container.instance :nested_repo do
        from_type NestedRepo
        inject_setters
        depends_on :simple_repo
      end
    end

    it 'returns a singleton instance of the logger, even if nested' do
      nested_repo = container.resolve(:nested_repo)
      logger = container.resolve(:logger)

      expect(nested_repo.simple_repo.logger == logger).to be_truthy
    end
  end

  describe 'resolving a complex, circular dependency chain' do
    before do
      container.instance :injectable_a do
        from_type InjectableA
        inject_setters
        depends_on :injectable_b
      end

      container.instance :injectable_b do
        from_type InjectableB
        depends_on :injectable_c
      end

      container.instance :injectable_c do
        from_type InjectableC
        inject_setters
        depends_on :injectable_a
      end
    end

    it 'returns a complete dependency graph' do
      result = container.resolve(:injectable_a)

      expect(result).to be_a(InjectableA)
      expect(result.injectable_b).to be_a(InjectableB)
      expect(result.injectable_b.injectable_c).to be_a(InjectableC)
      expect(result.injectable_b.injectable_c.injectable_a).to be_a(InjectableA)

      dep_a = result.injectable_b.injectable_c.injectable_a

      expect(result).to eq(dep_a)
    end
  end

  describe 'resolving a dependency chain of different injection types' do
    before do
      container.singleton :logger do
        from_value TestLogger.new
      end

      container.instance :simple_repo do
        from_type SimpleRepo
        depends_on :logger
      end

      container.instance :nested_repo do
        from_type NestedRepo
        inject_setters
        depends_on :simple_repo
      end

      container.instance :provided_repo do
        from_provider do |deps|
          ProvidedRepo.new(deps[:nested_repo])
        end
        depends_on :nested_repo
      end
    end

    it 'resolves a simple nested dependency' do
      result = container.resolve(:simple_repo)

      expect(result).to be_a(SimpleRepo)
      expect(result.logger).to be_a(TestLogger)
    end

    it 'resolves a mixed-type nested dependency' do
      result = container.resolve(:nested_repo)

      expect(result).to be_a(NestedRepo)
      expect(result.simple_repo).to be_a(SimpleRepo)
      expect(result.simple_repo.logger).to be_a(TestLogger)
    end

    it 'resolves a provided mixed-type nested dependency' do
      result = container.resolve(:provided_repo)

      expect(result).to be_a(ProvidedRepo)
      expect(result.nested_repo).to be_a(NestedRepo)
      expect(result.nested_repo.simple_repo).to be_a(SimpleRepo)
      expect(result.nested_repo.simple_repo.logger).to be_a(TestLogger)
    end
  end
end
