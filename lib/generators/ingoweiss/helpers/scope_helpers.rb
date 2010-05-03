module ScopeHelpers
  
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
  
  # Examples: 'post_comments', 'post_comment_approval'
  def scoped_controller_plural_name
    scope_prefix + (options[:singleton] ? singular_name : plural_name)
  end
  
  # Example: '@post, @comment, approval'
  def instance_variable_scope(variable=nil)
    instance_variables = scope.collect{|s| '@' + s.singularize}
    instance_variables << variable if variable
    instance_variables.join(', ')
  end
  
  # Examples: 'PostComments', 'PostCommentApproval'
  def scoped_controller_class_name
    scoped_controller_plural_name.camelize
  end
  
end