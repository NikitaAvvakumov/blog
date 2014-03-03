class CommentsController < ApplicationController

  before_action :signed_in_user, only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      @new_comment = @post.comments.new
      respond_to do |format|
        format.html do
          flash[:success] = 'Your comment has been posted.'
          redirect_to @post
        end
        format.js
      end
    else
      @new_comment = @comment
      respond_to do |format|
        format.html { render @post }
        format.js { render action: 'failed_save' }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    respond_to do |format|
      format.html do
        flash[:success] = 'Comment deleted.'
        redirect_to @post
      end
      format.js
    end
  end

  def index
    # created in order to handle renders from this controller, which produce URL 'root/posts/:id/comments'
    post = Post.find(params[:post_id])
    redirect_to post
  end

  private

    def comment_params
      params.require(:comment).permit(:author, :email, :content)
    end
end