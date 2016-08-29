require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe '#registered?' do
    it 'returns true if the given symbol is registered in the container' do
      container.register_singleton(:a_symbol, {})

      expect(container.registered?(:a_symbol)).to be_truthy
    end

    it 'returns false if the given symbol is not registered in the container' do
      expect(container.registered?(:a_different_symbol)).to be_falsey
    end
  end

  describe '#register' do
    it 'adds a symbol to the list of registered dependencies' do
      container.register(:a_symbol) { {} }

      expect(container.registered?(:a_symbol)).to be_truthy
    end

    it 'throws an exception if a block is not given' do
      expect { container.register(:a_symbol) }.to raise_error(ArgumentError)
    end
  end

  describe '#register_singleton' do
    it 'adds a symbol to the list of registered dependencies' do
      container.register_singleton(:a_symbol, {})

      expect(container.registered?(:a_symbol)).to be_truthy
    end

    it 'throws an exception unless a block or a value is given' do
      expect { container.register_singleton(:a_symbol) }
        .to raise_error(ArgumentError)
    end
  end

  describe '#resolve' do
    context 'when the symbol isn\'t registered' do
      it 'returns nil' do
        expect(container.resolve(:a_symbol)).to be_nil
      end
    end

    context 'when the symbol is registered' do
      it 'returns a value from the injectable' do
        container.register(:a_symbol) { :a_value }

        expect(container.resolve(:a_symbol)).to eq(:a_value)
      end
    end
  end
end
