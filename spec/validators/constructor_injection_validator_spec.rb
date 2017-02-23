require 'codependent/validators/constructor_injection_validator'

class KeywordClass
  def initialize(a_dependency:); end
end

class OptionalKeywordClass
  def initialize(a_dependency: nil); end
end

class NoKeywordClass
  def initialize(a_dependency); end
end

class NoArgsClass
  def initialize; end
end

describe Codependent::Validators::ConstructorInjectionValidator do
  let(:type) { :singleton }
  let(:simple_state) { { type: KeywordClass } }
  let(:optional_state) { { type: OptionalKeywordClass } }
  let(:no_keyword_state) { { type: NoKeywordClass } }
  let(:no_args_state) { { type: NoArgsClass } }
  let(:bad_state) { {} }

  let(:dependencies) { [:a_dependency, :another_dependency] }
  let(:no_dependencies) { [] }

  subject(:validator) do
    Codependent::Validators::ConstructorInjectionValidator.new
  end

  describe '#call' do
    it 'raises an exception of a class reference is not provided' do
      expect do
        validator.(type, bad_state, dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'raises an exception if the dependencies do not match the keyword args' do
      expect do
        validator.(type, simple_state, dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'raises an exception if initializer takes no args but has dependencies' do
      expect do
        validator.(type, no_args_state, dependencies)
      end.to raise_error(RuntimeError)
    end

    it 'does not raise if the class has a no-arg initializer and no dependencies' do
      expect do
        validator.(type, no_args_state, no_dependencies)
      end.to_not raise_error
    end

    it 'does not raise if the initializer has no keyword arguments' do
      expect do
        validator.(type, no_keyword_state, dependencies)
      end.to_not raise_error
    end
  end
end
