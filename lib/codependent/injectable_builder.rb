require 'codependent/injectable'

require 'codependent/validators/value_validator'
require 'codependent/validators/provider_validator'
require 'codependent/validators/constructor_injection_validator'
require 'codependent/validators/setter_injection_validator'

require 'codependent/resolvers/constructor_injection_resolver'
require 'codependent/resolvers/setter_injection_resolver'
require 'codependent/resolvers/provider_resolver'
require 'codependent/resolvers/value_resolver'

module Codependent
  class InjectableBuilder
    def initialize(type)
      @type = type
      @dependencies = []
      @state = {}
      @skip_checks = false
    end

    attr_reader :type, :dependencies, :state, :validator, :resolver

    def from_value(value)
      @state = { value: value }
      @validator = Validators::ValueValidator
      @resolver = Resolvers::ValueResolver
    end

    def from_provider(&block)
      @state = { provider: block }
      @validator = Validators::ProviderValidator
      @resolver = Resolvers::ProviderResolver
    end

    def from_type(klass, additional_args = nil)
      @state = {
        type: klass,
        additional_args: additional_args
      }

      @validator = Validators::ConstructorInjectionValidator
      @resolver = Resolvers::ConstructorInjectionResolver
    end

    def inject_setters
      @validator = Validators::SetterInjectionValidator
      @resolver = Resolvers::SetterInjectionResolver
    end

    def skip_checks
      @skip_checks = true
    end

    def depends_on(*dependencies)
      @dependencies.concat(dependencies)
    end

    def build
      @validator.new.(@type, @state, @dependencies) unless @skip_checks

      Injectable.new(@type, @dependencies, @state, @resolver)
    end
  end
end
