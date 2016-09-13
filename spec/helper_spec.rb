require 'spec_helper'
require 'codependent'

describe Codependent::Helper do
  before :each do
    Codependent::Manager.container(:test_container)
  end

  describe '.instance' do
    it 'adds this class as an injectable' do
      Struct.new(:logger) do
        extend Codependent::Helper

        instance :an_instance, in_container: :test_container do
          with_constructor { :a_value }
        end
      end

      expect(Codependent::Manager[:test_container].injectable?(:an_instance))
        .to be_truthy
    end
  end

  describe '.singleton' do
    it 'adds this class as an injectable' do
      Struct.new(:logger) do
        extend Codependent::Helper

        singleton :a_singleton, in_container: :test_container do
          with_value :a_value
        end
      end

      expect(Codependent::Manager[:test_container].injectable?(:a_singleton))
        .to be_truthy
    end
  end
end
