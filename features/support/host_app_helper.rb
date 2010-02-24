require 'fileutils'

module HostAppHelper
  
  HOST_APP_ROOT = '/tmp/ingoweiss_generators_host_app' unless defined? HOST_APP_ROOT
  
  def recreate_host_app
    FileUtils.rm_rf(HOST_APP_ROOT) if File.exist?(HOST_APP_ROOT)
    %x[rails #{HOST_APP_ROOT} -m #{PLUGIN_ROOT}/features/support/host_app_template.rb --quiet]
  end
  
  def vendor_plugin
    Dir.chdir File.join(HOST_APP_ROOT, 'vendor', 'plugins') do
      File.symlink PLUGIN_ROOT, 'ingoweiss_generators'
    end
  end
   
end