require File.join(File.dirname(__FILE__), 'helpers/test_helper')

include HostAppHelper

class GeneratedAppTest < ActionController::IntegrationTest
  
  def setup
    recreate_host_app
    install_ingoweiss_generators_into_host_app
    execute_in_host_app_root('rails generate ingoweiss:scaffold post title:string body:text --skip-route')
    execute_in_host_app_root('rails generate ingoweiss:scaffold comment body:text --scope=posts --skip-route')
    execute_in_host_app_root('rails generate ingoweiss:scaffold approval --scope=posts comments --skip-route --singleton')
    install_reference_app_routes
    migrate_host_app_db
    load_host_app
  end
  
  # TODO: Use webrat as soon as it is compatible with Rails 3
  def test_post_creation
    get '/posts'
    assert_response :success
    get '/posts/new'
    assert_response :success
    post '/posts', :post => {:title => 'Scaffolding for fun and profit', :body => 'Scaffolding can be useful if...'}
    follow_redirect!
    assert_response :success
    assert_not_nil Post.find_by_title('Scaffolding for fun and profit')
  end
  
  def test_post_comment_creation
    post = Post.create(:title => 'Scaffolding for fun and profit', :body => 'Scaffolding can be useful if...')
    get "/posts/#{post.to_param}/comments"
    assert_response :success
    get "/posts/#{post.to_param}/comments/new"
    assert_response :success
    post "/posts/#{post.to_param}/comments", :comment => {:body => 'Great post!'}
    follow_redirect!
    assert_response :success
    assert_not_nil post.comments.find_by_body('Great post!')
  end
  
  # def test_post_comment_approval_creation
  #   post = Post.create(:title => 'My first post', :body => 'Scaffolding for fun and profit')
  #   comment = post.comments.create(:body => 'Great post!')
  #   get "/posts/#{post.to_param}/comments/#{comment.to_param}/approval/new"
  #   assert_response :success
  #   post "/posts/#{post.to_param}/comments/#{comment.to_param}/approval"
  #   follow_redirect!
  #   assert_response :success
  #   assert_not_nil comment.approval
  # end
    
  
end