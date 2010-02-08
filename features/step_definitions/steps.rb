require File.join(File.dirname(__FILE__), *%w[.. support host_app_helper])
include HostAppHelper

Given /^a new rails app$/ do
  recreate_host_app
  vendor_plugin
end

When /^I generate a scaffold for the following resource:$/ do |table|
  attributes = table.hashes.first
  arguments = []
  arguments << attributes['name']
  arguments << attributes['attributes']
  arguments << '--singleton' if attributes['singleton'] == 'yes'
  arguments << '--scope ' + attributes['scope'] unless attributes['scope'].blank?
  Dir.chdir(HOST_APP_ROOT) do
    %x[rails generate ingoweiss:scaffold #{arguments.join(' ')}]
  end
end

Then /^the file '(.*)' should be generated$/ do |file_path|
  full_file_path = File.join(HOST_APP_ROOT, file_path)
  File.exists?(full_file_path).should be_true
  @generated_file = IO.read(full_file_path)
end

Then /^the generated file should look like '(.*)'$/ do |reference_template|
  @generated_file.should eql(IO.read(File.join(PLUGIN_ROOT, 'features', 'support', (reference_template + '.txt'))))
end