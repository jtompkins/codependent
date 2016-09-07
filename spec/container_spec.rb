require 'spec_helper'
require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }
  let(:id) { :a_symbol }
  let(:unregistered_id) { :a_different_symbol }
  let(:value) { :a_value }

  describe '#initialize' do
    context 'when a block is given' do
      it 'executes the block with the new instance in scope' do
        container = Codependent::Container.new do
          instance a_symbol: [:logger] { value }
        end

        expect(container.injectable?(id)).to be_truthy
      end
    end
  end

  describe '#injectable?' do
    context 'when the symbol is injectable' do
      it 'returns true' do
        container.singleton(id, {})

        expect(container.injectable?(id)).to be_truthy
      end
    end

    context 'when the symbol is not injectable' do
      it 'returns false' do
        expect(container.injectable?(unregistered_id)).to be_falsey
      end
    end
  end

  describe '#instance' do
    it 'throws an exception if a block is not given' do
      expect { container.instance(id) }.to raise_error(ArgumentError)
    end

    it 'returns the injectable' do
      value = container.instance(:a_symbol) { {} }

      expect(value).to be_a(Codependent::Injectable)
    end

    context 'when the injectable has no dependencies' do
      it 'uses the symbol as the key for the injectable' do
        container.instance(id) { value }
        expect(container.injectable?(id)).to be_truthy
      end
    end

    context 'when the injectable has dependencies' do
      it 'parses the id and dependencies from the hash' do
        injectable = container.instance(id => [:logger]) { value }

        expect(container.injectable?(id)).to be_truthy
        expect(injectable.depends_on?(:logger)).to be_truthy
      end
    end
  end

  describe '#singleton' do
    it 'throws an exception unless a block or a value is given' do
      expect { container.singleton(:a_symbol) }
        .to raise_error(ArgumentError)
    end

    it 'returns the injectable' do
      value = container.singleton(:a_symbol, {})

      expect(value).to be_a(Codependent::Injectable)
    end

    context 'when the injectable has no dependencies' do
      it 'uses the symbol as the key for the injectable' do
        container.singleton(id) { value }
        expect(container.injectable?(id)).to be_truthy
      end
    end

    context 'when the injectable has dependencies' do
      it 'parses the id and dependencies from the hash' do
        injectable = container.singleton(id => [:logger]) { value }

        expect(container.injectable?(id)).to be_truthy
        expect(injectable.depends_on?(:logger)).to be_truthy
      end
    end
  end

  describe '#resolve' do
    context 'when the symbol isn\'t injectable' do
      it 'returns nil' do
        expect(container.resolve(:a_symbol)).to be_nil
      end
    end

    it 'calls the resolver to handle resolution' do
      expect_any_instance_of(Codependent::DefaultResolver).to receive(:resolve)

      container.singleton(:a_symbol, :a_value)
      container.resolve(:a_symbol)
    end
  end
end
