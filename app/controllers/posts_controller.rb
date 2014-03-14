class PostsController < ApplicationController

  before_action :signed_in_user, except: [:index, :show]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
    @users = User.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @new_comment = @post.comments.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created.'
      redirect_to @post
    else
      render 'posts/new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = 'The post was updated.'
      redirect_to @post
    else
      render 'posts/edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = 'Post deleted.'
      redirect_to root_path
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :topic_id)
    end
end
