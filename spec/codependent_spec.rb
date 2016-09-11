require 'spec_helper'
require 'codependent'
require 'pry'
describe Codependent do
  let(:test_container) { :test }

  before :each do
    Codependent.clear
  end

  describe '.container' do
    context 'when the container does not exist' do
      it 'adds a new container' do
        Codependent.container(test_container)

        expect(Codependent.container?(test_container)).to be_truthy
      end

      it 'passes the optional config block to the new container' do
        Codependent.container(test_container) do
          singleton :a_singleton do
            with_value :a_value
          end
        end

        expect(Codependent[test_container].injectable?(:a_singleton))
          .to be_truthy
      end
    end

    context 'when the container exists' do
      it 'returns the existing container' do
        Codependent.container(test_container)

        expect(Codependent.container(test_container))
          .to be_a(Codependent::Container)
      end
    end
  end

  describe '.clear' do
    it 'removes all containers except the global' do
      Codependent.container(test_container)
      Codependent.clear

      expect(Codependent.container?(test_container)).to be_falsey
    end
  end

  describe '.[]' do
    it 'makes the container accessible via [] index' do
      Codependent.container(test_container)

      expect(Codependent[test_container]).to be_a(Codependent::Container)
    end
  end

  describe '.container?' do
    context 'when the container is defined' do
      it 'returns true' do
        Codependent.container(test_container)

        expect(Codependent.container?(test_container)).to be_truthy
      end
    end

    context 'when the container is not defined' do
      it 'returns false' do
        expect(Codependent.container?(test_container)).to be_falsey
      end
    end
  end
end
