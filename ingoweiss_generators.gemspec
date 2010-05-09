Gem::Specification.new do |gem|
  gem.name    = 'ingoweiss_generators'
  gem.version = '0.0.3'
  gem.summary = 'A collection of generators'
  gem.description = <<-DESCRIPTION
A collection of generators reflecting my personal preferences
DESCRIPTION
  gem.authors = ['Ingo Weiss']
  gem.email = 'ingo@ingoweiss.com'
  gem.files = Dir['lib/**/*']
  gem.add_dependency 'rails', '~> 3.0.0.beta1'
end