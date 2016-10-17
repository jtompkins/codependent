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
UserRepository = Struct.new(:logger)
AccountRepository = Struct.new(:logger, :user_repository)

# Create & configure a container by passing a block to the constructor:
container = Codependent::Container.new do
  # Transient or "instance" dependencies are configured with a simple
  # DSL.
  instance :logger do
    # The constructor block will be evaluated each time this dependency
    # is resolved. Whatever the block returns will be injected.
    with_constructor { Logger.new }
  end

  # Singleton dependencies are supported as well.
  singleton :user_repository do
    # Singletons can be resolved to a constant value.
    with_value UserRepository.new

    # You can specify nested dependencies, too:
    depends_on :logger

    # Codependent works through *Setter Injection*, so you'll need to have
    # a writable accessor of the same name as the dependency for injection to
    # occur.
    # In this case, we need `UserRepository` to have an accessor named `logger`.
  end

  # Singletons can also accept a constructor.
  singleton :account_repository do
    with_constructor { AccountRepository.new }
    # The constructor will be evaluated the first time the dependency is
    # resolved, and then the value will be re-used afterwards.

    # Your type can have more than one dependency. Circular dependencies are
    # resolved properly.
    depends_on :logger, :user_repository
  end
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
    with_constructor { Logger.new }
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

### Class Definition Syntax

```ruby
# Not everyone wants to configure the container up front. You can define your
# dependencies in your class definitions with the Codependent Helper.
class UserRepository
  extend Codependent::Helper

  # Tell Codependent what to call this injectable and how it should be resolved:
  singleton :user_repository do
    # The syntax here is the same as before.
    with_constructor { self.new }
    depends_on :logger
  end
end

class Logger
  extend Codependent::Helper

  # You can also specify the managed container into which this type should be
  # defined:
  instance :logger, in_container: :my_container do
    with_constructor { self.new }
  end
end
```

## Developing Codependent

### Building from source

1. Clone the repo.
2. Install dependencies: `bundle install`
3. Run the tests: `bundle exec rake ci`
4. Build a local copy of the gem: `gem build codependent.gemspec`
5. Install the gem locally: `gem install ./Codependent-0.1.gem`
6. Don't forget to version-bump the gemspec before publishing!
