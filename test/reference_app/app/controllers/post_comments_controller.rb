class PostCommentsController < ApplicationController 

  layout 'scaffold'
  respond_to :html, :xml, :json

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    respond_with @post, @comments
  end

  def show
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    respond_with @post, @comment
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    respond_with @post, @comment
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    respond_with @post, @comment
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])
    respond_with @post, @comment
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.update_attributes(params[:comment])
    respond_with @post, @comment
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    respond_with @post, @comment
  end

end
