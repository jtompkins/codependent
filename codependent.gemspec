Gem::Specification.new do |s|
  s.name        = 'codependent'
  s.version     = '0.4'
  s.date        = '2017-03-05'
  s.summary     = "A simple dependency injection library for Ruby."
  s.authors     = ["Joshua Tompkins"]
  s.email       = 'josh@joshtompkins.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = 'https://github.com/jtompkins/codependent'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop', '~> 0.40.0'
  s.add_development_dependency 'simplecov'
end
