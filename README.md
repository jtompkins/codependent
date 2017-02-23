# Codependent

Codependent is a simple, lightweight dependency injection library for Ruby.

[![Gem Version](https://badge.fury.io/rb/Codependent.png)](https://badge.fury.io/rb/Codependent)

## Codependent by Example

### Installation

```
gem install codependent
```

...or add Codependent to your Gemfile:

```
source 'https://rubygems.org'

gem 'codependent'
```

### Basic Usage

```ruby
# Let's define some injectable types.
Logger = Struct.new(:writer)

class UserRepository
  def initialize(logger:)
    @logger = logger
  end

  attr_reader :logger
end

class AccountRepository
  attr_accessor :logger, :user_repository
end

# Create & configure a container by passing a block to the constructor:
container = Codependent::Container.new do
  # Transient or "instance" dependencies are configured with a simple
  # DSL.
  instance :logger do
    # You can inject simple values:
    from_value Logger.new
  end

  # You can inject via the constructor:
  singleton :user_repository do
    from_type UserRepository
    depends_on :logger
  end

  # Codependent will pass the dependencies to the type's constructor.
  # The constructor needs to have keyword arguments that match the
  # type's dependencies. Codependent will raise an error if the keyword
  # arguments don't match the dependencies.

  # You can also inject via setters, useful to handle circular dependencies:
  singleton :account_repository do
    from_type AccountRepository
    inject_setters

    # Multiple dependencies are supported:
    depends_on :logger, :user_repository
  end

  # Codependent will call the setters to fill in the dependencies, and will
  # raise an error if there aren't setters for each dependency.

  # If you have an object with complex constructor requirements, you can
  # use a provider function:
  instance :db_connection do
    # Codependent will pass the dependencies to the provider block in a Hash.
    from_provider do |deps|
      DB.open(deps[:connection_string])
    end
  end

  # You can disable Codependent's type checking:
  instance :unchecked_dependency
    from_type MetaprogammingIsCool
    skip_checks
end

# Now that we've got our IoC container all wired up, we can ask it to give
# us instances of our types:
a_logger = container.resolve :logger # => a new instance of Logger
a_user_repo = container.resolve :user_repository # => An instance of UserRepository.
an_account_repo = container.resolve :account_repository # => An instance of Account Repository

# The user repository is defined as a singleton, so the references should be
# pointing at the same object.
expect(an_account_repo.user_repository).to eq(a_user_repo)

# The logger is a new instance each time it's resolved, so these won't be the
# same reference.
expect(a_user_repo.logger).not_to eq(a_logger)
```

## Advanced Usage

### Managing Containers

```ruby
# If you don't want to deal with managing the container yourself, Codependent
# can do it for you.

# You can create globally-accessible containers by giving the manager a name
# and configuring the container:
Codependent::Manager.container :my_container do
  # This block is passed to a new container instance and uses the same syntax
  # we've already seen.
  instance :logger do
    from_value Logger.new
  end
end

# Access the container through the manager:
a_logger = Codependent::Manager[:my_container].resolve(:logger)

# Test to see if a container is defined:
Codependent::Manager.container?(:my_container) # => True

# You can reset a container you've defined back to it's original configuration:
Codependent::Manager.reset_container!(:my_container)

# ...or just remove all of them:
Codependent::Manager.reset!
```

## Developing Codependent

### Building from source

1. Clone the repo.
2. Install dependencies: `bundle install`
3. Run the tests: `bundle exec rake ci`
4. Build a local copy of the gem: `gem build codependent.gemspec`
5. Install the gem locally: `gem install ./codependent-0.2.gem`
6. Don't forget to version-bump the gemspec before publishing!
