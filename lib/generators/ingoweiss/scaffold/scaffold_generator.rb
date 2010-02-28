require 'rails/generators/resource_helpers'
require 'rails/generators/migration'

module Ingoweiss
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
    include Rails::Generators::Migration
  
    argument :name, :type => :string, :required => true
    argument :attributes, :type => :array, :required => false, :banner => 'field:type field:type'
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false, :desc => 'Is this a singleton resource?'
    class_option :'skip-route', :type => :boolean, :default => false, :desc => 'Do not add route to config/routes.rb'
  
    def self.source_root
      @source_root ||= File.expand_path('../../templates', __FILE__)
    end
  
    def generate_controllers
      template 'controller.erb', "app/controllers/#{scoped_controller_plural_name}_controller.rb"
    end
    
    def add_routes
      route "resource#{'s' unless options[:singleton]} :#{options[:singleton] ? singular_name : plural_name}" unless options[:'skip-route']
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
    
    def generate_erb
      template 'index.html.erb', "app/views/#{scoped_controller_plural_name}/index.html.erb" unless options[:singleton]
      template '_entry.html.erb', "app/views/#{scoped_controller_plural_name}/_#{singular_name}.html.erb"
      template 'new.html.erb', "app/views/#{scoped_controller_plural_name}/new.html.erb"
      template 'edit.html.erb', "app/views/#{scoped_controller_plural_name}/edit.html.erb"
      template '_form.html.erb', "app/views/#{scoped_controller_plural_name}/_form.html.erb"
      template 'show.html.erb', "app/views/#{scoped_controller_plural_name}/show.html.erb"
      template 'layout.html.erb', "app/views/layouts/scaffold.html.erb" unless File.exists?(File.join(destination_root, 'app/views/layouts/scaffold.html.erb'))
      invoke :stylesheets
    end
    
    def inject_link_to_children
      return if singleton? || unscoped?
      parent_resource_view_folder = (scope[0..-2].collect(&:singularize) << scope.last).join('_')
      append_file "app/views/#{parent_resource_view_folder}/show.html.erb", "<%= link_to 'Show #{plural_name}', #{scope_prefix}#{plural_name}_path(#{instance_variable_scope}) %>\n"
    end
    
    private
    
    def scope
      options[:scope]
    end
    
    def scoped?
      scope.any?
    end
    
    def unscoped?
      !scoped?
    end
    
    def singleton?
      options[:singleton]
    end
    
    # Example: 'post_comment_' for post_comment_approval_path
    def scope_prefix
      scope.collect{|s| s.singularize + '_'}.join
    end
    
    # Example: '@post, @comment, approval'
    def instance_variable_scope(variable=nil)
      instance_variables = scope.collect{|s| '@' + s.singularize}
      instance_variables << variable if variable
      instance_variables.join(', ')
    end
    
    # Examples: 'post_comments', 'post_comment_approval'
    def scoped_controller_plural_name
      scope_prefix + (options[:singleton] ? singular_name : plural_name)
    end
    
    # Examples: 'PostComments', 'PostCommentApproval'
    def scoped_controller_class_name
      scoped_controller_plural_name.camelize
    end
    
    def controller_retrieve_scope
      lines = []
      scope.each_with_index do |scope_item, index|
        if index == 0
          lines << "@#{scope_item.singularize} = #{scope_item.singularize.classify}.find(params[:#{scope_item.singularize}_id])"
        else
          previous_scope_item = scope[index-1]
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
      if scope.any?
        if options[:singleton]
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.singularize}"
        else
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.pluralize}.find(params[:id])"
        end
      else
        "@#{name.singularize} = #{name.singularize.classify}.find(params[:id])"
      end
    end
    
    def controller_retrieve_collection
      if scope.any?
        "@#{name.pluralize} = @#{scope.last.singularize}.#{name.pluralize}"
      else
        "@#{name.pluralize} = #{name.singularize.classify}.all"
      end
    end
    
    def controller_build_resource
      if scope.any?
        if options[:singleton]
          "@#{name.singularize} = @#{scope.last.singularize}.build_#{name.singularize}(params[:#{name.singularize}])"
        else
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.pluralize}.build(params[:#{name.singularize}])"
        end
      else
        "@#{name.singularize} = #{name.singularize.classify}.new(params[:#{name.singularize}])"
      end
    end
    
    def controller_create_resource
      if scope.any?
        if options[:singleton]
          "@#{name.singularize} = @#{scope.last.singularize}.create_#{name.singularize}(params[:#{name.singularize}])"
        else
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.pluralize}.create(params[:#{name.singularize}])"
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
      "respond_with #{(scope.collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.pluralize]).join(', ')}"
    end
  
    def controller_respond_with_resource
      "respond_with #{(scope.collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.singularize]).join(', ')}"
    end
  
  end
end
