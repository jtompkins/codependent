require 'codependent/validators/value_validator'

describe Codependent::Validators::ValueValidator do
  let(:state) do
    {
      value: :a_value
    }
  end

  let(:nil_value_state) do
    {
      value: nil
    }
  end

  let(:no_dependencies) { [] }
  let(:dependencies) { [:a_dependency] }

  subject(:validator) { Codependent::Validators::ValueValidator.new }

  describe '#call' do
    it 'raises an exception if the injectable is not a singleton' do
      expect do
        validator.(:instance, state, no_dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'raises an exception if the value is nil' do
      expect do
        validator.(:singleton, nil_value_state, no_dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'raises an exception if any dependencies are specified' do
      expect do
        validator.(:singleton, state, dependencies)
      end.to raise_error(RuntimeError)
    end
  end
end
