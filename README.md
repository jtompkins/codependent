# Codependent

Codependent is a simple, lightweight dependency injection library for Ruby.

## Introducing the Container

```ruby
container = Codependent::Container.new do
  singleton :a_dependency do
    with_value :a_value
  end
end
```

## Defining dependencies

### Singletons

#### Resolving to a constant value

```ruby
Codependent::Container.new do
  singleton :a_singleton do
    with_value :a_value
  end
end
```

#### Lazy evaluation

```ruby
Codependent::Container.new do
  singleton :a_singleton do
    with_constructor { :another_value }
  end
end
```

### Instances

```ruby
Codependent::Container.new do
  instance :an_instance do
    with_constructor { :an_instance_value }
  end
end
```

### Nested dependencies

```ruby
Codependent::Container.new do
  instance :an_instance do
    with_constructor { AClassWithDependencies.new }
    depends_on :another_injectable
  end
end
```

## Resolving a dependency

```ruby
Codependent::Container.resolve :a_dependency # == :a_value
```

## Working with the Container Manager

### Creating a new container

```ruby
Codependent::Manager.container :a_container do
  singleton :a_singleton do
    with_value :a_value
  end
end
```

### Accessing your container

```ruby
Codependent::Manager[:a_container].resolve :a_singleton # :a_value
```

#### The `global` container

```ruby
Codependent::Manager.global.resolve :a_singleton
```

### Is a container defined?

```ruby
Codependent::Manager.container?(:a_container) # true
```

### Resetting the containers

```ruby
Codependent::Manager.reset!
```

#### Resetting a single container

```ruby
Codependent::Manager.reset_container!(:a_container)
```

## Class Definition Syntax

```ruby
class AClass
  extend Codependent::Helper

  instance :a_class do
    with_constructor { self.new }
    depends_on :another_injectable
  end
end
```
