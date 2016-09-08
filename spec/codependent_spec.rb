require 'spec_helper'
require 'codependent'
require 'pry'
describe Codependent do
  let(:test_scope) { :test }

  before :each do
    Codependent.reset
  end

  describe '.scope' do
    context 'when the scope does not exist' do
      it 'adds a new scope' do
        Codependent.scope(test_scope)

        expect(Codependent.scope?(test_scope)).to be_truthy
      end

      it 'passes the optional config block to the new container' do
        Codependent.scope(test_scope) do
          singleton :a_singleton do
            with_value :a_value
          end
        end

        expect(Codependent[test_scope].injectable?(:a_singleton))
          .to be_truthy
      end
    end

    context 'when the scope exists' do
      it 'returns the existing scope' do
        Codependent.scope(test_scope)

        expect(Codependent.scope(test_scope)).to be_a(Codependent::Container)
      end
    end
  end

  describe '.reset' do
    it 'removes all scopes except the global scope' do
      Codependent.scope(test_scope)
      Codependent.reset

      expect(Codependent.scope?(test_scope)).to be_falsey
    end
  end

  describe '.[]' do
    it 'makes the scope accessible via [] index' do
      Codependent.scope(test_scope)

      expect(Codependent[test_scope]).to be_a(Codependent::Container)
    end
  end

  describe '.scope?' do
    context 'when the scope is defined' do
      it 'returns true' do
        Codependent.scope(test_scope)

        expect(Codependent.scope?(test_scope)).to be_truthy
      end
    end

    context 'when the scope is not defined' do
      it 'returns false' do
        expect(Codependent.scope?(test_scope)).to be_falsey
      end
    end
  end
end
