require 'codependent'

describe Codependent::Injectable do
  describe '#resolve' do
    let(:callback) { -> { :a_value } }

    context 'when resolving an instance injectable' do
      let(:injectable) { Codependent::Injectable.instance(callback) }

      it 'returns the value returned by the block' do
        expect(injectable.resolve).to eq(:a_value)
      end

      it 'calls the block each time #resolve is called' do
        expect(callback).to receive(:call).twice

        injectable.resolve
        injectable.resolve
      end
    end

    context 'when resolving a singleton injectable' do
      context 'when a value was given' do
        let(:injectable) { Codependent::Injectable.singleton(:a_value, nil) }

        it 'returns the value' do
          expect(injectable.resolve).to eq(:a_value)
        end
      end

      context 'when a block was given' do
        let(:injectable) { Codependent::Injectable.singleton(nil, callback) }

        it 'calls the block only the first time #resolve is called' do
          expect(callback).to receive(:call).once.and_call_original

          injectable.resolve
          injectable.resolve
        end

        it 'returns the value returned by the block' do
          expect(injectable.resolve).to eq(:a_value)
        end
      end
    end
  end

  describe '#depends_on' do
    let(:injectable) { Codependent::Injectable.singleton(:a_value, nil) }

    it 'appends a symbol to the list of dependencies' do
      injectable.depends_on(:another_key, :and_another_key)

      expect(injectable.dependencies).to eq([:another_key, :and_another_key])
    end
  end
end
