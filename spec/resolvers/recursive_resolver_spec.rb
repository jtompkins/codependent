require 'spec_helper'
require 'codependent'

describe Codependent::Resolvers::RecursiveResolver do
  let(:resolver_klass) { double(:resolver_klass) }
  let(:injection_resolver) { double(:injection_resolver) }

  let(:nested_injectable) do
    Codependent::Injectable.new(:singleton, [:simple_injectable], {}, resolver_klass)
  end

  let(:simple_injectable) do
    Codependent::Injectable.new(:singleton, [], {}, resolver_klass)
  end

  let(:injectables) do
    {
      simple_injectable: simple_injectable,
      nested_injectable: nested_injectable
    }
  end

  let(:expected_result) { :a_value }

  subject(:resolver) { Codependent::Resolvers::RecursiveResolver.new(injectables) }

  before do
    allow(resolver_klass).to receive(:new).and_return(injection_resolver)
    allow(injection_resolver).to receive(:call).and_return(expected_result)
  end

  describe '#call' do
    context 'when the injectable has no dependencies' do
      it 'resolves the dependency' do
        expect(injection_resolver).to receive(:call).once

        expect(resolver.(:simple_injectable)).to eq(expected_result)
      end
    end

    context 'when the injectable has dependencies' do
      it 'resolves the nested dependency' do
        expect(injection_resolver).to receive(:call).twice

        result = resolver.(:nested_injectable)

        expect(result).to eq(expected_result)
      end
    end
  end
end
