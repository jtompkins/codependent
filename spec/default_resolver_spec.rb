require 'spec_helper'
require 'codependent'

describe Codependent::DefaultResolver do
  describe '#resolve' do
    let(:simple_dependency) { double(value: :a_value, dependencies: []) }
    let(:logger) { double(value: :a_logger, dependencies: []) }

    let(:depends_on_logger) do
      double(value: Struct.new(:logger).new, dependencies: [:logger])
    end

    let(:depends_on_an_injectable) do
      double(
        value: Struct.new(:depends_on_logger).new,
        dependencies: [:depends_on_logger]
      )
    end

    let(:depends_on_b) do
      double(
        value: Struct.new(:depends_on_b).new,
        dependencies: [:depends_on_b]
      )
    end

    let(:depends_on_a) do
      double(
        value: Struct.new(:depends_on_a).new,
        dependencies: [:depends_on_a]
      )
    end

    let(:injectables) do
      {
        a_dependency: simple_dependency
      }
    end

    subject(:resolver) { Codependent::DefaultResolver.new(injectables) }

    context 'when the dependency chain is not nested' do
      it 'returns a value from the injectable' do
        expect(resolver.resolve(:a_dependency)).to eq(:a_value)
      end
    end

    context 'when there are dependencies' do
      let(:injectables) do
        {
          a_dependency: depends_on_logger,
          logger: logger
        }
      end

      it 'injects the dependencies' do
        value = resolver.resolve(:a_dependency)

        expect(value.logger).to eq(:a_logger)
      end
    end

    context 'when there are nested dependencies' do
      let(:injectables) do
        {
          depends_on_an_injectable: depends_on_an_injectable,
          depends_on_logger: depends_on_logger,
          logger: logger
        }
      end

      it 'injects the all dependencies in the chain' do
        value = resolver.resolve(:depends_on_an_injectable)

        expect(value).to_not be_nil
        expect(value.depends_on_logger).to_not be_nil
        expect(value.depends_on_logger.logger).to eq(:a_logger)
      end
    end

    context 'when there are circular dependencies' do
      let(:injectables) do
        {
          depends_on_a: depends_on_a,
          depends_on_b: depends_on_b
        }
      end

      it 'handles circular dependencies' do
        value = resolver.resolve(:depends_on_b)

        expect(value).to_not be_nil
        expect(value.depends_on_b).to_not be_nil
      end
    end
  end
end
