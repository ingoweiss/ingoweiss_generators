module ScopeHelper
  
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
  
end