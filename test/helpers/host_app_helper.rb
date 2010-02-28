require 'fileutils'

module HostAppHelper
  
  HOST_APP_ROOT = '/tmp/ingoweiss_generators_host_app' unless defined? HOST_APP_ROOT
  INGOWEISS_GENERATORS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..')) unless defined? INGOWEISS_GENERATORS_ROOT
  
  def recreate_host_app
    FileUtils.rm_rf(HOST_APP_ROOT) if File.exist?(HOST_APP_ROOT)
    %x[rails #{HOST_APP_ROOT} -m #{INGOWEISS_GENERATORS_ROOT}/test/helpers/host_app_template.rb --quiet]
  end
  
  def install_ingoweiss_generators_into_host_app
    Dir.chdir(HOST_APP_ROOT + '/vendor/plugins') do
      File.symlink(INGOWEISS_GENERATORS_ROOT, 'ingoweiss_generators')
    end
  end
  
  def install_reference_app_routes
    FileUtils.cp(INGOWEISS_GENERATORS_ROOT + '/test/reference_app/config/routes.rb', HOST_APP_ROOT + '/config/routes.rb')
  end
  
  def load_host_app
    Dir.chdir(HOST_APP_ROOT) do
      ENV["RAILS_ENV"] = "test"
      require File.expand_path(File.join(HOST_APP_ROOT, 'config', 'environment'))
    end
  end
  
  def execute_in_host_app_root(command)
    Dir.chdir(HOST_APP_ROOT) do
      %x[#{command}]
    end
  end
  
  def migrate_host_app_db
    Dir.chdir(HOST_APP_ROOT) do
      %x[rake db:create:all db:migrate db:test:clone_structure]
    end
  end
  
end