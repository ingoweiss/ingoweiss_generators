require 'rails/generators/resource_helpers'
require 'rails/generators/migration'

module Ingoweiss
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
    include Rails::Generators::Migration
  
    argument :name, :type => :string, :required => true
    argument :resource_attributes, :type => :hash, :required => false, :banner => 'field:type field:type'
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false
    class_option :'skip-routes', :type => :boolean, :default => false
  
    def self.source_root
      @source_root ||= File.expand_path('../../templates', __FILE__)
    end
  
    def generate_controllers
      template 'controller.erb', "app/controllers/#{scoped_controller_plural_name}_controller.rb"
    end
    
    def add_routes
      route "resource#{'s' unless options[:singleton]} :#{options[:singleton] ? singular_name : plural_name}" unless options[:'skip-routes']
    end
    
    # def generate_migration
    #   migration_template 'migration.erb', "db/migrate/create_#{plural_name}.rb"
    # end
    
    private
    
    def scoped_controller_plural_name
      (options[:scope].collect{|i| i.singularize} + [options[:singleton] ? singular_name : plural_name]).join('_')
    end
    
    def scoped_controller_class_name
      scoped_controller_plural_name.camelize
    end
    
    def controller_retrieve_scope
      lines = []
      options[:scope].each_with_index do |scope_item, index|
        if index == 0
          lines << "@#{scope_item.singularize} = #{scope_item.singularize.classify}.find(params[:#{scope_item.singularize}_id])"
        else
          previous_scope_item = options[:scope][index-1]
          if scope_item.pluralize == scope_item
            lines << "@#{scope_item.singularize} = @#{previous_scope_item.singularize}.#{scope_item.pluralize}.find(params[:#{scope_item.singularize}_id])"
          else
            lines << "@#{scope_item.singularize} = @#{previous_scope_item.singularize}.#{scope_item.singularize}"
          end
        end
      end
      lines
    end
    
    def controller_retrieve_resource
      if options[:scope].any?
        if options[:singleton]
          "@#{name.singularize} = @#{options[:scope].last.singularize}.#{name.singularize}"
        else
          "@#{name.singularize} = @#{options[:scope].last.singularize}.#{name.pluralize}.find(params[:id])"
        end
      else
        "@#{name.singularize} = #{name.singularize.classify}.find(params[:id])"
      end
    end
    
    def controller_retrieve_collection
      if options[:scope].any?
        "@#{name.pluralize} = @#{options[:scope].last.singularize}.#{name.pluralize}"
      else
        "@#{name.pluralize} = #{name.singularize.classify}.all"
      end
    end
    
    def controller_build_resource
      if options[:scope].any?
        if options[:singleton]
          "@#{name.singularize} = @#{options[:scope].last.singularize}.build_#{name.singularize}(params[:#{name.singularize}])"
        else
          "@#{name.singularize} = @#{options[:scope].last.singularize}.#{name.pluralize}.build(params[:#{name.singularize}])"
        end
      else
        "@#{name.singularize} = #{name.singularize.classify}.new(params[:#{name.singularize}])"
      end
    end
    
    def controller_create_resource
      if options[:scope].any?
        if options[:singleton]
          "@#{name.singularize} = @#{options[:scope].last.singularize}.create_#{name.singularize}(params[:#{name.singularize}])"
        else
          "@#{name.singularize} = @#{options[:scope].last.singularize}.#{name.pluralize}.create(params[:#{name.singularize}])"
        end
        
      else
        "@#{name.singularize} = #{name.singularize.classify}.create(params[:#{name.singularize}])"
      end
    end
    
    def controller_destroy_resource
      "@#{name.singularize}.destroy"
    end
    
    def controller_update_resource
      "@#{name.singularize}.update_attributes(params[:#{name.singularize}])"
    end
    
    def controller_respond_with_collection
      "respond_with #{(options[:scope].collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.pluralize]).join(', ')}"
    end
  
    def controller_respond_with_resource
      "respond_with #{(options[:scope].collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.singularize]).join(', ')}"
    end
  
  end
end
