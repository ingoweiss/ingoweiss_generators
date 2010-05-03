class PostCommentApprovalController < ActionController::Base

  before_filter :scope
  respond_to :html, :xml, :json
  layout 'scaffold'

  def show
    @approval = @comment.approval
    respond_with @post, @comment, @approval
  end

  def new
    @approval = @comment.build_approval
    respond_with @post, @comment, @approval
  end

  def edit
    @approval = @comment.approval
    respond_with @post, @comment, @approval
  end

  def create
    @approval = @comment.create_approval
    respond_with @post, @comment, @approval
  end

  def update
    @approval = @comment.approval
    @approval.update_attributes
    respond_with @post, @comment, @approval
  end

  def destroy
    @approval = @comment.approval
    @approval.destroy
    respond_with @post, @comment, @approval
  end

  private

  def scope
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
  end

end
