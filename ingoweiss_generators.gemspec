Gem::Specification.new do |gem|
  gem.name    = 'ingoweiss_generators'
  gem.version = '0.0.6'
  gem.summary = 'A collection of Rails generators'
  gem.description = <<-DESCRIPTION
A collection of Rails generators reflecting my personal coding preferences
DESCRIPTION
  gem.authors = ['Ingo Weiss']
  gem.email = 'ingo@ingoweiss.com'
  gem.homepage = 'http://www.github.com/ingoweiss/ingoweiss_generators'
  gem.files = Dir['lib/**/*']
  gem.add_dependency 'rails', '3.0.0'
end