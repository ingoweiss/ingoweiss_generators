require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = '--tags ~@wip --no-source'
end

require 'rake/testtask'

desc 'Run test/unit tests'
Rake::TestTask.new(:test) { |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  # t.warning = true
}


task :default => [:features]