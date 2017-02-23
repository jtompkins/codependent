require 'spec_helper'
require 'codependent'

describe Codependent::Manager do
  let(:test_container) { :test }

  before :each do
    Codependent::Manager.reset!
  end

  describe '.reset!' do
    it 'removes all containers except the global' do
      Codependent::Manager.container(test_container)
      Codependent::Manager.reset!

      expect(Codependent::Manager.container?(test_container)).to be_falsey
    end
  end

  describe '#container' do
    context 'when the container does not exist' do
      it 'adds a new container' do
        Codependent::Manager.container(test_container)

        expect(Codependent::Manager.container?(test_container)).to be_truthy
      end

      it 'passes the optional config block to the new container' do
        Codependent::Manager.container(test_container) do
          singleton :a_singleton do
            from_value :a_value
          end
        end

        expect(Codependent::Manager[test_container].injectable?(:a_singleton))
          .to be_truthy
      end
    end

    context 'when the container exists' do
      it 'returns the existing container' do
        Codependent::Manager.container(test_container)

        expect(Codependent::Manager.container(test_container))
          .to be_a(Codependent::Container)
      end
    end
  end

  describe '#reset_container!' do
    it 'rebuilds the container from the config block' do
      counter = 0
      config = -> (_) { counter += 1 }

      Codependent::Manager.container(test_container, &config)
      Codependent::Manager.reset_container!(test_container)

      expect(counter).to eq(2)
    end

    it 'returns the new container' do
      Codependent::Manager.container(test_container)

      expect(Codependent::Manager.reset_container!(test_container))
        .to be_a(Codependent::Container)
    end
  end

  describe '#[]' do
    it 'makes the container accessible via [] index' do
      Codependent::Manager.container(test_container)

      expect(Codependent::Manager[test_container])
        .to be_a(Codependent::Container)
    end
  end

  describe '#global' do
    it 'returns the global container' do
      expect(Codependent::Manager.global)
        .to eq(Codependent::Manager[:global])
    end
  end

  describe '#container?' do
    context 'when the container is defined' do
      it 'returns true' do
        Codependent::Manager.container(test_container)

        expect(Codependent::Manager.container?(test_container)).to be_truthy
      end
    end

    context 'when the container is not defined' do
      it 'returns false' do
        expect(Codependent::Manager.container?(test_container)).to be_falsey
      end
    end
  end
end
