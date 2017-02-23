require 'spec_helper'
require 'codependent'

class TestClass
  def initialize(simple_dependency:)
    @simple_dependency = simple_dependency
  end

  attr_reader :simple_dependency
end

class SetterDependencyA
  attr_accessor :setter_dependency_b
end

class SetterDependencyB
  attr_accessor :setter_dependency_a
end

describe Codependent::Resolvers::RootResolver do
  let(:eager_resolver) do
    Codependent::Resolvers::EagerTypeResolver
  end

  let(:deferred_resolver) do
    Codependent::Resolvers::DeferredTypeResolver
  end

  let(:value_resolver) do
    Codependent::Resolvers::ValueResolver
  end

  describe '#resolve' do
    context 'when dependencies can be eagerly resolved' do
      let(:simple_dependency) do
        Codependent::Injectable.new(
          :singleton,
          [],
          { value: :a_value },
          value_resolver
        )
      end

      let(:nested_dependency) do
        Codependent::Injectable.new(
          :singleton,
          [:simple_dependency],
          { type: TestClass },
          eager_resolver
        )
      end

      let(:injectables) do
        {
          simple_dependency: simple_dependency,
          nested_dependency: nested_dependency
        }
      end

      it 'resolves a dependency' do
        resolver = Codependent::Resolvers::RootResolver.new(injectables)

        result = resolver.resolve(:nested_dependency)

        expect(result).to be_a(TestClass)
      end
    end

    context 'when a dependency must be deferred' do
      let(:setter_dependency_a) do
        Codependent::Injectable.new(
          :singleton,
          [:setter_dependency_b],
          { type: SetterDependencyA },
          deferred_resolver
        )
      end

      let(:setter_dependency_b) do
        Codependent::Injectable.new(
          :singleton,
          [:setter_dependency_a],
          { type: SetterDependencyB },
          deferred_resolver
        )
      end

      let(:setter_injectables) do
        {
          setter_dependency_a: setter_dependency_a,
          setter_dependency_b: setter_dependency_b
        }
      end

      it 'resolves a dependency' do
        resolver = Codependent::Resolvers::RootResolver
                   .new(setter_injectables)

        result = resolver.resolve(:setter_dependency_a)

        expect(result).to be_a(SetterDependencyA)
        expect(result.setter_dependency_b).to be_a(SetterDependencyB)
      end
    end
  end
end
