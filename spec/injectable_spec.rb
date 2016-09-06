require 'spec_helper'
require 'codependent'

describe Codependent::Injectable do
  describe '#value' do
    let(:value) { :a_value }
    let(:callback) { -> { value } }

    context 'when resolving an instance injectable' do
      subject(:injectable) { Codependent::Injectable.instance(callback) }

      it 'returns the value returned by the block' do
        expect(injectable.value).to eq(value)
      end

      it 'calls the block each time #value is called' do
        expect(callback).to receive(:call).twice

        injectable.value
        injectable.value
      end
    end

    context 'when resolving a singleton injectable' do
      context 'when a value was given' do
        subject(:injectable) { Codependent::Injectable.singleton(value, nil) }

        it 'returns the value' do
          expect(injectable.value).to eq(value)
        end
      end

      context 'when a block was given' do
        subject(:injectable) do
          Codependent::Injectable.singleton(nil, callback)
        end

        it 'calls the block only the first time #value is called' do
          expect(callback).to receive(:call).once.and_call_original

          injectable.value
          injectable.value
        end

        it 'returns the value returned by the block' do
          expect(injectable.value).to eq(value)
        end
      end
    end
  end

  describe '#depends_on' do
    subject(:injectable) { Codependent::Injectable.singleton(:a_value, nil) }
    let(:dependencies) { [:another_key, :and_another_key] }

    it 'returns the injectable' do
      value = injectable.depends_on(:a_test_key)

      expect(value).to eq(injectable)
    end

    it 'appends a symbol to the list of dependencies' do
      injectable.depends_on(*dependencies)

      expect(injectable.dependencies).to eq(dependencies)
    end
  end

  describe '#depends_on?' do
    subject(:injectable) do
      Codependent::Injectable
        .instance(:an_injectable) { :a_value }
        .depends_on(:a_dependency)
    end

    context 'when the injectable depends on the ID' do
      it 'returns true' do
        expect(injectable.depends_on?(:a_dependency)).to be_truthy
      end
    end

    context 'when the injectable does not depend on the ID' do
      it 'returns false' do
        expect(injectable.depends_on?(:another_dependency)).to be_falsey
      end
    end
  end
end
