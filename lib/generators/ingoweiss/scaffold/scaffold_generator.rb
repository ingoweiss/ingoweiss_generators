require 'rails/generators/resource_helpers'

module Ingoweiss
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
  
    argument :name, :type => :string, :required => true
    argument :resource_attributes, :type => :hash, :required => false, :banner => 'field:type field:type'
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false
  
    def self.source_root
      @source_root ||= File.expand_path('../../templates', __FILE__)
    end
  
    def generate_controllers
      template 'controller.erb', "app/controllers/#{plural_name}_controller.rb"
    end
  
  end
end
