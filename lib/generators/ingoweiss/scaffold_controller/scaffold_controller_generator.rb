require File.expand_path('../../helpers/scope_helper', __FILE__)

module Ingoweiss
  class ScaffoldControllerGenerator < Rails::Generators::NamedBase
    
    include ScopeHelper
    argument :attributes, :type => :array, :required => false #only needed to determine whether resource HAS attributes or not. Maybe use boolean option --attributes instead?
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false, :desc => 'Is this a singleton resource?'
  
    def self.source_root
      @source_root ||= File.expand_path('../templates', __FILE__)
    end
  
    def generate_controller
      template 'controller.erb', "app/controllers/#{scoped_controller_plural_name}_controller.rb"
    end
    
    private
    
    # Examples: 'post_comments', 'post_comment_approval'
    def scoped_controller_plural_name
      scope_prefix + (options.singleton? ? singular_name : plural_name)
    end
    
    # Examples: 'PostComments', 'PostCommentApproval'
    def scoped_controller_class_name
      scoped_controller_plural_name.camelize
    end
    
    def controller_retrieve_scope
      lines = []
      options.scope.each_with_index do |scope_item, index|
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
      if options.scope.any?
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
      if options.scope.any?
        "@#{name.pluralize} = @#{scope.last.singularize}.#{name.pluralize}"
      else
        "@#{name.pluralize} = #{name.singularize.classify}.all"
      end
    end
    
    def controller_build_resource
      if options.scope.any?
        if options[:singleton]
          "@#{name.singularize} = @#{scope.last.singularize}.build_#{name.singularize}" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
        else
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.pluralize}.build" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
        end
      else
        "@#{name.singularize} = #{name.singularize.classify}.new" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
      end
    end
    
    def controller_create_resource
      if options.scope.any?
        if options[:singleton]
          "@#{name.singularize} = @#{scope.last.singularize}.create_#{name.singularize}" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
        else
          "@#{name.singularize} = @#{scope.last.singularize}.#{name.pluralize}.create" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
        end
        
      else
        "@#{name.singularize} = #{name.singularize.classify}.create" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
      end
    end
    
    def controller_destroy_resource
      "@#{name.singularize}.destroy"
    end
    
    def controller_update_resource
      "@#{name.singularize}.update_attributes" + (attributes.any? ? "(params[:#{name.singularize}])" : '')
    end
    
    def controller_respond_with_collection
      "respond_with #{(options.scope.collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.pluralize]).join(', ')}"
    end
  
    def controller_respond_with_resource
      "respond_with #{(options.scope.collect{|scope_item| '@' + scope_item.singularize} + ['@' + name.singularize]).join(', ')}"
    end          
    
  end
end
