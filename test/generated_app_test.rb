require File.join(File.dirname(__FILE__), 'helpers/test_helper')

class GeneratedAppTest < ActionController::IntegrationTest
  
  def setup
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
  
  def test_post_comment_approval_creation
    post = Post.create(:title => 'My first post', :body => 'Scaffolding for fun and profit')
    comment = post.comments.create(:body => 'Great post!')
    get "/posts/#{post.to_param}/comments/#{comment.to_param}/approval/new"
    assert_response :success
    post "/posts/#{post.to_param}/comments/#{comment.to_param}/approval"
    assert_not_nil comment.approval
  end
    
  
end