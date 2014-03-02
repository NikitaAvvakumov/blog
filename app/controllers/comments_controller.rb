class CommentsController < ApplicationController

  before_action :signed_in_user, only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Your comment has been posted.'
      redirect_to @post
    else
      @new_comment = @comment
      render template: 'posts/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    post = @comment.post
    if @comment.destroy
      flash[:success] = 'Comment deleted.'
      redirect_to post
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
