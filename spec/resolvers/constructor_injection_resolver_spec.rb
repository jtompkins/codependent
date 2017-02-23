require 'codependent/resolvers/constructor_injection_resolver'

describe Codependent::Resolvers::ConstructorInjectionResolver do
  let(:klass) { double(:klass) }

  let(:simple_state) do
    {
      klass: klass,
    }
  end

  let(:state_with_args) do
    {
      klass: klass,
      additional_args: { an_arg: 'value' }
    }
  end

  let(:dependencies) do
    {
      a_dependency: :a_value
    }
  end

  subject(:resolver) do
    Codependent::Resolvers::ConstructorInjectionResolver.new
  end

  before do
    allow(klass).to receive(:new)
  end

  describe '#call' do
    it 'calls the constructor and passes dependencies' do
      expect(klass).to receive(:new).with(**dependencies)

      resolver.(simple_state, dependencies)
    end

    context 'when additional arguments are provided' do
      it 'adds the additional arguments to the constructor parameters' do
        expect(klass).to receive(:new).with(
          **dependencies,
          **state_with_args[:additional_args]
        )

        resolver.(state_with_args, dependencies)
      end
    end
  end
end
