require 'spec_helper'
require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe '#injectable?' do
    context 'when the symbol is injectable' do
      it 'returns true' do
        container.singleton(:a_symbol, {})

        expect(container.injectable?(:a_symbol)).to be_truthy
      end
    end

    context 'when the symbol is not injectable' do
      it 'returns false' do
        expect(container.injectable?(:a_different_symbol)).to be_falsey
      end
    end
  end

  describe '#instance' do
    it 'returns the injectable' do
      value = container.instance(:a_symbol) { {} }

      expect(value).to be_a(Codependent::Injectable)
    end

    it 'adds a symbol to the list of injectables' do
      container.instance(:a_symbol) { {} }

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'throws an exception if a block is not given' do
      expect { container.instance(:a_symbol) }.to raise_error(ArgumentError)
    end
  end

  describe '#singleton' do
    it 'returns the injectable' do
      value = container.singleton(:a_symbol, {})

      expect(value).to be_a(Codependent::Injectable)
    end

    it 'adds a symbol to the list of injectables' do
      container.singleton(:a_symbol, {})

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'throws an exception unless a block or a value is given' do
      expect { container.singleton(:a_symbol) }
        .to raise_error(ArgumentError)
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
