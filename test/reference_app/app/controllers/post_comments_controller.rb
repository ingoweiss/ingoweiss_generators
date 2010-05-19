class PostCommentsController < ApplicationController

  before_filter :scope
  respond_to :html, :xml, :json
  layout 'scaffold'

  def index
    @comments = @post.comments
    respond_with @post, @comments
  end

  def show
    @comment = @post.comments.find(params[:id])
    respond_with @post, @comment
  end

  def new
    @comment = @post.comments.build(params[:comment])
    respond_with @post, @comment
  end

  def edit
    @comment = @post.comments.find(params[:id])
    respond_with @post, @comment
  end

  def create
    @comment = @post.comments.create(params[:comment])
    respond_with @post, @comment
  end

  def update
    @comment = @post.comments.find(params[:id])
    @comment.update_attributes(params[:comment])
    respond_with @post, @comment
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    respond_with @post, @comment
  end

  private

  def scope
    @post = Post.find(params[:post_id])
  end

end
