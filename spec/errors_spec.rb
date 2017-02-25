require 'spec_helper'
require 'codependent'

describe Codependent::Errors::MissingTypeError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::MissingTypeError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::MissingKeywordArgError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::MissingKeywordArgError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::MissingAccessorError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::MissingAccessorError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::NoConstructorArgsError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::NoConstructorArgsError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::MissingProviderBlockError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::MissingProviderBlockError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::ValueDependencyError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::ValueDependencyError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::NoValueError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::NoValueError.new.message).to be_a(String)
    end
  end
end

describe Codependent::Errors::ValueOnInstanceError do
  describe '#message' do
    it 'returns a message' do
      expect(Codependent::Errors::ValueOnInstanceError.new.message).to be_a(String)
    end
  end
end
