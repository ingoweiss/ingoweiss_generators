IngoweissGeneratorsHostApp::Application.routes.draw do |map|
  resources :posts do
    resources :comments, :controller => 'post_comments' do
      resource :approval, :controller => 'post_comment_approval'
    end
  end
end
