require 'fileutils'

module HostAppHelper
  
  HOST_APP_ROOT = '/tmp/ingoweiss_generators_host_app' unless defined? HOST_APP_ROOT
  INGOWEISS_GENERATORS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..')) unless defined? INGOWEISS_GENERATORS_ROOT
  
  def recreate_host_app
    FileUtils.rm_rf(HOST_APP_ROOT) if File.exist?(HOST_APP_ROOT)
    system "INGOWEISS_GENERATORS_ROOT='#{INGOWEISS_GENERATORS_ROOT}' rails #{HOST_APP_ROOT} -m #{INGOWEISS_GENERATORS_ROOT}/test/helpers/host_app_template.rb"
  end
  
  def install_reference_app_routes
    FileUtils.cp(INGOWEISS_GENERATORS_ROOT + '/test/reference_app/config/routes.rb', HOST_APP_ROOT + '/config/routes.rb')
  end
  
  def load_host_app
    in_host_app_root do
      ENV["RAILS_ENV"] = "test"
      require File.expand_path(File.join(HOST_APP_ROOT, 'config', 'environment'))
    end
  end
  
  def in_host_app_root(&block)
    Dir.chdir(HOST_APP_ROOT) do
      yield
    end
  end
  
  def migrate_host_app_db
    in_host_app_root do
      system "rake db:create:all db:migrate db:test:clone_structure"
    end
  end
  
end