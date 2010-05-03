require File.expand_path('../../helpers/scope_helpers', __FILE__)
require 'rails/generators/resource_helpers'

module Ingoweiss
  class ScaffoldViewsGenerator < Rails::Generators::NamedBase
    
    include Rails::Generators::ResourceHelpers
    include ScopeHelpers
    
    argument :attributes, :type => :array, :required => false, :banner => 'field:type field:type'
    class_option :scope, :type => :array, :default => [], :banner => 'grand_parent parent', :desc => 'Indicate parent resource(s) if nested'
    class_option :singleton, :type => :boolean, :default => false, :desc => 'Is this a singleton resource?'
    
    def self.source_root
      @source_root ||= File.expand_path('../templates', __FILE__)
    end
    
    def generate_views
      template 'index.html.erb',    "app/views/#{scoped_controller_plural_name}/index.html.erb" unless options[:singleton]
      template '_entry.html.erb',   "app/views/#{scoped_controller_plural_name}/_#{singular_name}.html.erb"
      template 'new.html.erb',      "app/views/#{scoped_controller_plural_name}/new.html.erb"
      template 'edit.html.erb',     "app/views/#{scoped_controller_plural_name}/edit.html.erb"
      template '_fields.html.erb',  "app/views/#{scoped_controller_plural_name}/_fields.html.erb"
      template 'show.html.erb',     "app/views/#{scoped_controller_plural_name}/show.html.erb"
      template 'layout.html.erb',   "app/views/layouts/scaffold.html.erb" unless File.exists?(File.join(destination_root, 'app/views/layouts/scaffold.html.erb'))
      invoke :stylesheets
    end
    
    def inject_link_to_children_index
      return if singleton? || unscoped?
      parent_resource_view_folder = (scope[0..-2].collect(&:singularize) << scope.last).join('_')
      append_file "app/views/#{parent_resource_view_folder}/show.html.erb", "<%= link_to 'Show #{plural_name}', #{scope_prefix}#{plural_name}_path(#{instance_variable_scope}) %>\n"
    end
    
  end
end
