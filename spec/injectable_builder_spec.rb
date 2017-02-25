require 'spec_helper'
require 'codependent'

class TestClass; end

describe Codependent::InjectableBuilder do
  let(:id) { :test_id }
  let(:instance) { :instance }
  let(:dependencies) { [:dependency] }

  let(:value) { :a_value }
  let(:value_state) { { value: value } }

  subject(:builder) { Codependent::InjectableBuilder.new(id, :singleton) }

  describe '#initialize' do
    it 'sets the type' do
      a_builder = Codependent::InjectableBuilder.new(id, instance)

      expect(a_builder.type).to eq(:instance)
    end

    it 'sets the dependencies to an empty array' do
      expect(builder.dependencies.empty?).to be_truthy
    end
  end

  describe '#from_type' do
    let(:klass) { TestClass }
    let(:type_state) { { type: klass, additional_args: nil } }

    before do
      builder.from_type klass
    end

    it 'sets the state' do
      expect(builder.state).to eq(type_state)
    end

    it 'sets the validator' do
      expect(builder.validator)
        .to eq(Codependent::Validators::ConstructorInjectionValidator)
    end

    it 'sets the resolver' do
      expect(builder.resolver)
        .to eq(Codependent::Resolvers::EagerTypeResolver)
    end
  end

  describe '#inject_setters' do
    before do
      builder.inject_setters
    end

    it 'sets the validator' do
      expect(builder.validator)
        .to eq(Codependent::Validators::SetterInjectionValidator)
    end

    it 'sets the resolver' do
      expect(builder.resolver)
        .to eq(Codependent::Resolvers::DeferredTypeResolver)
    end
  end

  describe '#from_provider' do
    let(:provider) { -> { true } }
    let(:provider_state) { { provider: provider } }

    before do
      builder.from_provider(&provider)
    end

    it 'sets the state' do
      expect(builder.state).to eq(provider_state)
    end

    it 'sets the validator' do
      expect(builder.validator)
        .to eq(Codependent::Validators::ProviderValidator)
    end

    it 'sets the resolver' do
      expect(builder.resolver)
        .to eq(Codependent::Resolvers::ProviderResolver)
    end
  end

  describe '#from_value' do
    before do
      builder.from_value value
    end

    it 'sets the state' do
      expect(builder.state).to eq(value_state)
    end

    it 'sets the validator' do
      expect(builder.validator)
        .to eq(Codependent::Validators::ValueValidator)
    end

    it 'sets the resolver' do
      expect(builder.resolver)
        .to eq(Codependent::Resolvers::ValueResolver)
    end
  end

  describe '#depends_on' do
    it 'sets the dependencies' do
      builder.depends_on(*dependencies)

      expect(builder.dependencies).to eq(dependencies)
    end
  end

  describe '#injectable' do
    let(:validator) { double(:value_validator) }

    before do
      builder.from_value value
    end

    it 'builds an injectable' do
      expect(builder.build).to be_a(Codependent::Injectable)
    end

    it 'calls the validator' do
      expect(builder.validator)
        .to receive(:new)
        .and_return(validator)

      expect(validator).to receive(:call).with(:singleton, value_state, [])

      builder.build
    end

    context 'when #skip_checks was called' do
      it 'skips validation' do
        builder.skip_checks

        expect(validator).to_not receive(:call)

        builder.build
      end
    end
  end
end
