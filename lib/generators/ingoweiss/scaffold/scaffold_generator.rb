require 'rails/generators/resource_helpers'
require 'rails/generators/migration'
require File.join(File.dirname(__FILE__), '../helpers/scope_helpers') 

module Ingoweiss
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
    include Rails::Generators::Migration
    include ScopeHelpers
  
    argument :attributes, :type => :array, :required => false, :banner => 'field:type field:type'
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false, :desc => 'Is this a singleton resource?'
    class_option :skip_route, :type => :boolean, :default => false, :desc => 'Do not add route to config/routes.rb'
    
    hook_for :scaffold_controller
  
    def self.source_root
      @source_root ||= File.expand_path('../../templates', __FILE__)
    end
      
    def add_routes
      return if options[:skip_route]
      route "resource#{'s' unless options[:singleton]} :#{options[:singleton] ? singular_name : plural_name}"
    end
    
    def generate_model
      arguments = [singular_name] + attributes.collect{ |a| [a.name, a.type].join(':') }
      arguments << "#{scope.last.singularize}_id:integer" if scope.any?
      invoke :model, arguments
    end
    
    def inject_associations
      return if scope.empty?
      parent = scope.last.singularize
      inject_into_file("app/models/#{parent}.rb", :after => /< ActiveRecord::Base\n/) do
        options[:singleton] ? "  has_one :#{singular_name}\n" : "  has_many :#{plural_name}\n"
      end
      inject_into_file("app/models/#{singular_name}.rb", :after => /< ActiveRecord::Base\n/) do
        "  belongs_to :#{parent}\n"
      end
    end
  
  end
end
