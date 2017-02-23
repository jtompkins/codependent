require 'spec_helper'
require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe '#initialize' do
    context 'when a block is given' do
      it 'executes the block with the new instance in scope' do
        instance_type = nil

        Codependent::Container.new do
          instance_type = self.class
        end

        expect(instance_type).to eq(Codependent::Container)
      end
    end
  end

  describe '#injectable' do
    context 'when the injectable exists' do
      before do
        container.singleton(:a_symbol) do
          from_value :a_value
        end
      end

      it 'returns the injectable' do
        expect(container.injectable(:a_symbol)).to be_a(Codependent::Injectable)
      end
    end

    context 'when the injectable does not exist' do
      it 'returns nil' do
        expect(container.injectable(:a_random_symbol)).to be_nil
      end
    end
  end

  describe '#injectable?' do
    context 'when the symbol is injectable' do
      before do
        container.singleton(:a_symbol) do
          from_value :a_value
        end
      end

      it 'returns true' do
        expect(container.injectable?(:a_symbol)).to be_truthy
      end
    end

    context 'when the symbol is not injectable' do
      it 'returns false' do
        expect(container.injectable?(:another_symbol)).to be_falsey
      end
    end
  end

  describe '#instance' do
    it 'throws an exception if a block is not given' do
      expect { container.instance(:a_symbol) }.to raise_error(ArgumentError)
    end

    it 'executes the block given' do
      block = -> { :a_value }
      expect(block).to receive(:call)

      container.instance(:a_symbol) do
        block.call
      end
    end

    it 'adds the injectable to the list of injectables' do
      container.instance(:a_symbol) do
        from_provider { :a_value }
      end

      expect(container.injectable?(:a_symbol)).to be_truthy
    end
  end

  describe '#singleton' do
    it 'throws an exception if a block is not given' do
      expect { container.singleton(:a_symbol) }.to raise_error(ArgumentError)
    end

    it 'executes the block given' do
      block = -> { :a_value }
      expect(block).to receive(:call)

      container.singleton(:a_symbol) do
        block.call
      end
    end

    it 'adds the injectable to the list of injectables' do
      container.singleton(:a_symbol) do
        from_value :a_value
      end

      expect(container.injectable?(:a_symbol)).to be_truthy
    end
  end

  describe '#resolve' do
    before do
      container.instance(:a_dependency) do
        from_provider { :a_value }
      end
    end

    it 'returns a resolved value' do
      expect(container.resolve(:a_dependency)).to eq(:a_value)
    end

    context 'when the symbol is not injectable' do
      it 'returns nil' do
        expect(container.resolve(:a_symbol)).to be_nil
      end
    end

    context 'when the dependency is a singleton' do
      before do
        container.singleton(:a_singleton) do
          from_value Object.new
        end
      end

      it 'returns the same value each time' do
        result1 = container.resolve(:a_singleton)
        result2 = container.resolve(:a_singleton)

        expect(result1 == result2).to be_truthy
      end
    end
  end
end
