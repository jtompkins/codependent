require 'spec_helper'
require 'codependent'

describe Codependent::Helper do
  let(:scoped_injectable) do
    Struct.new(:logger) do
      extend Codependent::Helper

      in_scope :test_scope
      instance :scoped_injectable
    end
  end

  before :all do
    Codependent.scope(:test_scope)
  end

  describe '.scope' do
    it 'sets the scope to the given scope id' do
      expect(scoped_injectable.scope).to eq(:test_scope)
    end
  end

  describe '.instance' do
    it 'adds this class as an injectable' do
      expect(Codependent[:test_scope].injectable?(:scoped_injectable))
        .to be_truthy
    end

    context 'when no scope is given' do
      it 'defines the injectable in the global scope' do
        Struct.new(:logger) do
          extend Codependent::Helper

          instance :injectable
        end

        expect(Codependent.global.injectable?(:injectable)).to be_truthy
      end
    end
  end

  describe '.singleton' do
    context 'no value or block is provided' do
      it 'adds this class as an injectable' do
        Struct.new(:logger) do
          extend Codependent::Helper

          singleton :singleton_injectable
        end

        expect(Codependent.global.injectable?(:singleton_injectable))
          .to be_truthy
      end
    end

    context 'when a value is provided for the singleton' do
      it 'adds this class as an injectable' do
        Struct.new(:logger) do
          extend Codependent::Helper

          singleton :singleton_injectable, :a_value
        end

        expect(Codependent.global.injectable?(:singleton_injectable))
          .to be_truthy
      end
    end
  end

  describe '.depends_on' do
    it 'raises an error if you did not define the injectable first' do
      expect do
        Struct.new(:logger) do
          extend Codependent::Helper

          depends_on :logger
        end
      end.to raise_error(StandardError)
    end

    it 'adds the dependencies to the injectable' do
      Struct.new(:logger) do
        extend Codependent::Helper

        instance :dependency_injectable
        depends_on :logger
      end

      injectable = Codependent
                   .global
                   .instance_variable_get(:@injectables)[:dependency_injectable]

      expect(injectable.depends_on?(:logger)).to be_truthy
    end
  end
end
