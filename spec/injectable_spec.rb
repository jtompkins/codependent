require 'spec_helper'
require 'codependent'

describe Codependent::Injectable do
  let(:value) { :a_value }
  let(:constructor) { -> { value } }
  let(:dependencies) { [:a_dependency] }

  let(:instance) do
    Codependent::Injectable.new(:instance, dependencies, nil, constructor)
  end

  let(:singleton) do
    Codependent::Injectable.new(:singleton, dependencies, nil, constructor)
  end

  let(:singleton_value) do
    Codependent::Injectable.new(:singleton, dependencies, value)
  end

  describe '#singleton?' do
    context 'when the injectable is a singleton' do
      it 'returns true' do
        expect(singleton.singleton?).to be_truthy
      end
    end

    context 'when the injectable is not a singleton' do
      it 'returns false' do
        expect(instance.singleton?).to be_falsey
      end
    end
  end

  describe 'instance?' do
    context 'when the injectable is a instance' do
      it 'returns true' do
        expect(instance.instance?).to be_truthy
      end
    end

    context 'when the injectable is not a instance' do
      it 'returns false' do
        expect(singleton.instance?).to be_falsey
      end
    end
  end

  describe 'depends_on?' do
    context 'when the injectable depends on the id' do
      it 'returns true' do
        expect(instance.depends_on?(:a_dependency)).to be_truthy
      end
    end

    context 'when the injectable does not depend on the id' do
      it 'returns false' do
        expect(instance.depends_on?(:another_dependency)).to be_falsey
      end
    end
  end

  describe '#value' do
    context 'when resolving an instance injectable' do
      it 'returns the value returned by the block' do
        expect(instance.value).to eq(value)
      end

      it 'calls the block each time #value is called' do
        expect(constructor).to receive(:call).twice

        instance.value
        instance.value
      end
    end

    context 'when resolving a singleton injectable' do
      context 'when a value was given' do
        it 'returns the value' do
          expect(singleton_value.value).to eq(value)
        end
      end

      context 'when a block was given' do
        it 'calls the block only the first time #value is called' do
          expect(constructor).to receive(:call).once.and_call_original

          singleton.value
          singleton.value
        end

        it 'returns the value returned by the block' do
          expect(singleton.value).to eq(value)
        end
      end
    end
  end
end
