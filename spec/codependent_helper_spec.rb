require 'spec_helper'
require 'codependent'
require 'pry'

describe Codependent::Helper do
  context 'when it is extended in a class' do
    before do
      Codependent::Container.add_scope(:test_scope)
    end

    describe '.in_scope' do
      it 'sets the scope to the given scope id' do
        scope_type = Struct.new(:a_value) do
          extend Codependent::Helper

          in_scope :test_scope
        end

        expect(scope_type.instance_variable_get(:@scope)).to eq(:test_scope)
      end
    end

    describe '.instance' do
      it 'adds this class as an injectable' do
        Struct.new(:logger) do
          extend Codependent::Helper

          in_scope :test_scope
          instance :instance_test
        end

        injectable = Codependent::Container
                     .test_scope
                     .injectable?(:instance_test)

        expect(injectable).to be_truthy
      end

      context 'when no scope is given' do
        it 'defines the injectable in the global scope' do
          Struct.new(:logger) do
            extend Codependent::Helper

            instance :instance_global_test
          end

          injectable = Codependent::Container
                       .global
                       .injectable?(:instance_global_test)

          expect(injectable).to be_truthy
        end
      end
    end

    describe '.singleton' do
      it 'adds this class as an injectable' do
        Struct.new(:logger) do
          extend Codependent::Helper

          in_scope :test_scope
          singleton :singleton_test
        end

        injectable = Codependent::Container
                     .test_scope
                     .injectable?(:singleton_test)

        expect(injectable).to be_truthy
      end
    end

    describe '.depends_on' do
      it 'adds the dependencies to the injectable' do
        Struct.new(:logger) do
          extend Codependent::Helper

          in_scope :test_scope
          instance :dependency_test
          depends_on :logger
        end

        injectable = Codependent::Container
                     .test_scope
                     .instance_variable_get(:@injectables)[:dependency_test]

        dependencies = injectable.instance_variable_get(:@dependencies)

        expect(dependencies.include?(:logger)).to be_truthy
      end
    end
  end
end
