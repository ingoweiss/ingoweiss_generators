class PostCommentApprovalController < ApplicationController 

  layout 'scaffold'
  respond_to :html, :xml, :json

  def show
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    @approval = @comment.approval
    respond_with @post, @comment, @approval
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    @approval = @comment.build_approval
    respond_with @post, @comment, @approval
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    @approval = @comment.create_approval
    respond_with @post, @comment, @approval
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    @approval = @comment.approval
    @approval.destroy
    respond_with @post, @comment, @approval
  end

end
