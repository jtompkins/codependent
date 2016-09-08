require 'spec_helper'
require 'codependent'

describe Codependent::Container do
  subject(:container) { Codependent::Container.new }

  describe '#initialize' do
    context 'when a block is given' do
      it 'executes the block with the new instance in scope' do
        container = Codependent::Container.new do
          instance :a_symbol do
            with_constructor { :a_value }
          end

          singleton :a_singleton do
            with_value :a_value
          end
        end

        expect(container.injectable?(:a_symbol)).to be_truthy
        expect(container.injectable?(:a_singleton)).to be_truthy
      end
    end
  end

  describe '#injectable?' do
    context 'when the symbol is injectable' do
      it 'returns true' do
        container.singleton(:a_symbol) do
          with_value :a_value
        end

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

    it 'returns the injectable' do
      value = container.instance(:a_symbol) do
        with_constructor { :a_value }
      end

      expect(value).to be_a(Codependent::Injectable)
    end

    it 'adds the injectable to the list of injectables' do
      container.instance(:a_symbol) do
        with_constructor { :a_value }
      end

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'executes the config block to build the injectable' do
      ran_constructor = false

      container.instance(:a_symbol) do
        with_constructor { :a_value }

        ran_constructor = true
      end

      expect(ran_constructor).to be_truthy
    end
  end

  describe '#singleton' do
    it 'throws an exception if a block is not given' do
      expect { container.singleton(:a_symbol) }.to raise_error(ArgumentError)
    end

    it 'returns the injectable' do
      value = container.singleton(:a_symbol) do
        with_value :a_value
      end

      expect(value).to be_a(Codependent::Injectable)
    end

    it 'adds the injectable to the list of injectables' do
      container.singleton(:a_symbol) do
        with_value :a_value
      end

      expect(container.injectable?(:a_symbol)).to be_truthy
    end

    it 'executes the config block to build the injectable' do
      ran_constructor = false

      container.singleton(:a_symbol) do
        with_value :a_value

        ran_constructor = true
      end

      expect(ran_constructor).to be_truthy
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

      container.singleton(:a_symbol) do
        with_value :a_value
      end

      container.resolve(:a_symbol)
    end
  end
end
