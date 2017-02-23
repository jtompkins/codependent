require 'codependent/resolvers/setter_injection_resolver'

describe Codependent::Resolvers::SetterInjectionResolver do
  let(:klass) { double(:klass) }
  let(:instance) { double(:klass_instance) }

  let(:state) do
    {
      klass: klass,
    }
  end

  let(:dependencies) do
    {
      a_dependency: :a_value
    }
  end

  subject(:resolver) do
    Codependent::Resolvers::SetterInjectionResolver.new
  end

  before do
    allow(klass).to receive(:new).and_return(instance)
  end

  describe '#call' do
    it 'calls the constructor and all of the setters' do
      expect(klass).to receive(:new)

      dependencies.each do |key, value|
        expect(instance).to receive("#{key}=".to_sym).with(value)
      end

      resolver.(state, dependencies)
    end
  end
end
