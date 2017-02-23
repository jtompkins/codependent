require 'spec_helper'
require 'codependent'

describe Codependent::Resolvers::SetterInjectionResolver do
  let(:klass) { double(:klass) }
  let(:instance) { double(:klass_instance) }

  let(:state) do
    { type: klass }
  end

  let(:dependencies) do
    { a_dependency: :a_value }
  end

  subject(:resolver) do
    Codependent::Resolvers::SetterInjectionResolver.new
  end

  before do
    allow(klass).to receive(:new).and_return(instance)
  end

  describe '#call' do
    it 'calls the constructor' do
      expect(klass).to receive(:new)

      resolver.(state, dependencies)
    end
  end

  describe '#apply' do
    it 'calls the setters' do
      dependencies.each do |key, value|
        expect(instance).to receive("#{key}=".to_sym).with(value)
      end

      resolver.apply(instance, dependencies)
    end
  end
end
