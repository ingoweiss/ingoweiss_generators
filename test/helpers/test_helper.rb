ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), 'host_app_helper')
include HostAppHelper

recreate_host_app
in_host_app_root do
  system 'rails generate ingoweiss:scaffold post title:string body:text --skip-route'
  system 'rails generate ingoweiss:scaffold comment body:text --scope=posts --skip-route'
  system 'rails generate ingoweiss:scaffold approval --scope=posts comments --skip-route --singleton'
end
install_reference_app_routes
migrate_host_app_db
load_host_app

require 'rails/test_help'
