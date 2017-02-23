require 'codependent/validators/setter_injection_validator'

class SettersClass
  attr_accessor :a_dependency
end

describe Codependent::Validators::SetterInjectionValidator do
  let(:type) { :singleton }

  let(:setter_state) { { type: SettersClass } }
  let(:bad_state) { {} }

  let(:dependencies) { [:a_dependency] }
  let(:more_dependencies) { [:a_dependency, :another_dependency] }

  subject(:validator) { Codependent::Validators::SetterInjectionValidator.new }

  describe '#call' do
    it 'raises an exception of a class reference is not provided' do
      expect do
        validator.(type, bad_state, dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'raises an exception if the dependencies do not match the accessors' do
      expect do
        validator.(type, setter_state, more_dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'does not raise if the class has all of the accessors' do
      expect do
        validator.(type, setter_state, dependencies)
      end.to_not raise_error
    end
  end
end
