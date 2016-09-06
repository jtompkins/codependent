Gem::Specification.new do |s|
  s.name        = 'Codependent'
  s.version     = '0.1'
  s.date        = '2016-08-28'
  s.summary     = "A simple dependency injection library for Ruby."
  s.authors     = ["Joshua Tompkins"]
  s.email       = 'josh@joshtompkins.com'
  s.files       = [
                    "lib/codependent.rb",
                    "lib/codependent/container.rb",
                    "lib/codependent/injectable.rb",
                    "lib/codependent/default_resolver.rb",
                    "lib/codependent/helper.rb"
                  ]
  s.homepage    =
    'https://github.com/jtompkins/codependent'
  s.license       = 'MIT'
end
