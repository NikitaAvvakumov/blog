class TopicsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
    @posts = Post.where(topic: @topic)
  end

  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'New topic created.'
      redirect_to topics_path
    else
      render 'topics/new'
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    redirect_to topics_path
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Topic name updated.'
      redirect_to topics_path
    else
      render 'topics/edit'
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:name)
    end
end
