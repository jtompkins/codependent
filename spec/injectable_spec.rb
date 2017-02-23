require 'spec_helper'
require 'codependent'

describe Codependent::Injectable do
  let(:dependencies) { [:a_dependency] }
  let(:state) { {} }
  let(:resolver) { Codependent::Resolvers::ValueResolver }

  let(:instance) do
    Codependent::Injectable.new(:instance, dependencies, state, resolver)
  end

  let(:singleton) do
    Codependent::Injectable.new(:singleton, dependencies, state, resolver)
  end

  describe '#singleton?' do
    context 'when the injectable is a singleton' do
      it 'returns true' do
        expect(singleton.singleton?).to be_truthy
      end
    end

    context 'when the injectable is not a singleton' do
      it 'returns false' do
        expect(instance.singleton?).to be_falsey
      end
    end
  end

  describe 'instance?' do
    context 'when the injectable is a instance' do
      it 'returns true' do
        expect(instance.instance?).to be_truthy
      end
    end

    context 'when the injectable is not a instance' do
      it 'returns false' do
        expect(singleton.instance?).to be_falsey
      end
    end
  end

  describe 'depends_on?' do
    context 'when the injectable depends on the id' do
      it 'returns true' do
        expect(instance.depends_on?(:a_dependency)).to be_truthy
      end
    end

    context 'when the injectable does not depend on the id' do
      it 'returns false' do
        expect(instance.depends_on?(:another_dependency)).to be_falsey
      end
    end
  end
end
