require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe '#injectable?' do
    it 'returns true if the given symbol is defined in the container' do
      container.singleton(:a_symbol, {})

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'returns false if the given symbol is not defined in the container' do
      expect(container.injectable?(:a_different_symbol)).to be_falsey
    end
  end

  describe '#instance' do
    it 'adds a symbol to the list of injectables' do
      container.instance(:a_symbol) { {} }

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'throws an exception if a block is not given' do
      expect { container.instance(:a_symbol) }.to raise_error(ArgumentError)
    end
  end

  describe '#singleton' do
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

    context 'when the symbol is injectable' do
      it 'returns a value from the injectable' do
        container.instance(:a_symbol) { :a_value }

        expect(container.resolve(:a_symbol)).to eq(:a_value)
      end

      context 'when the injectable has dependencies' do
        it 'injects the dependencies' do
          Testable = Struct.new(:logger)

          container.singleton(:logger, :a_logger)

          container
            .instance(:testable) { Testable.new }
            .depends_on(:logger)

          value = container.resolve(:testable)

          expect(value.logger).to eq(:a_logger)
        end
      end
    end
  end
end
