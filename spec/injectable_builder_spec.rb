require 'spec_helper'
require 'codependent'

describe Codependent::InjectableBuilder do
  subject(:builder) { Codependent::InjectableBuilder.new(:instance) }
  let(:value) { :value }
  let(:constructor) { -> { value } }
  let(:dependencies) { [:dependency] }

  describe '#initialize' do
    it 'sets the type' do
      a_builder = Codependent::InjectableBuilder.new(:instance)

      expect(a_builder.type).to eq(:instance)
    end

    it 'sets the dependencies to an empty array' do
      expect(builder.dependencies.empty?).to be_truthy
    end
  end

  describe '#with_constructor' do
    it 'sets the constructor' do
      builder.with_constructor(&constructor)

      expect(builder.constructor).to eq(constructor)
    end
  end

  describe '#with_value' do
    it 'sets the singleton value' do
      builder.with_value(value)

      expect(builder.value).to eq(value)
    end
  end

  describe '#depends_on' do
    it 'sets the dependencies' do
      builder.depends_on(*dependencies)

      expect(builder.dependencies).to eq(dependencies)
    end
  end

  describe '#injectable' do
    it 'builds a new Codependent::Injectable instance' do
      builder.with_constructor(&constructor)
      expect(builder.injectable).to be_a(Codependent::Injectable)
    end

    context 'when the injectable is an instance' do
      context 'when the constructor is not set' do
        it 'raises an error' do
          an_instance_builder = Codependent::InjectableBuilder.new(:instance)

          expect { an_instance_builder.injectable }
            .to raise_error(StandardError)
        end
      end
    end

    context 'when the injectable is a singleton' do
      context 'when the constructor and value are not set' do
        it 'raises an error' do
          an_instance_builder = Codependent::InjectableBuilder.new(:singleton)

          expect { an_instance_builder.injectable }
            .to raise_error(StandardError)
        end
      end
    end
  end
end
