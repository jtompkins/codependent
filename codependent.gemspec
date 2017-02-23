Gem::Specification.new do |s|
  s.name        = 'codependent'
  s.version     = '0.2'
  s.date        = '2017-02-23'
  s.summary     = "A simple dependency injection library for Ruby."
  s.authors     = ["Joshua Tompkins"]
  s.email       = 'josh@joshtompkins.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = 'https://github.com/jtompkins/codependent'
  s.license     = 'MIT'
end
