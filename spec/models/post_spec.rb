require 'spec_helper'

describe Post do
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { Topic.create(name: 'Code') }
  before { @post = user.posts.build(title: 'A new post', body: 'This is a new blog post.', topic: topic) }

  subject { @post }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should respond_to :user_id }
  it { should respond_to :user }
  it { should respond_to :topic }
  it { should respond_to :topic_id }
  its(:user) { should eq user }
  it { should respond_to :comments }
  it { should be_valid }

  describe 'validations' do
    context 'when title is missing' do
      before { @post.title = '' }
      it { should_not be_valid }
    end

    context 'when body is missing' do
      before { @post.body = '' }
      it { should_not be_valid }
    end

    context 'when user_id is missing' do
      before { @post.user_id = nil }
      it { should_not be_valid }
    end
  end

  describe 'comment associations' do
    before { @post.save }
    let!(:newer_comment) { FactoryGirl.create(:comment, post: @post, created_at: 1.hour.ago) }
    let!(:older_comment) { FactoryGirl.create(:comment, post: @post, created_at: 1.day.ago) }
    let!(:newest_comment) { FactoryGirl.create(:comment, post: @post, created_at: 1.minute.ago) }

    it 'should retreive comments in chronological order' do
      expect(@post.comments.to_a).to eq [older_comment, newer_comment, newest_comment]
    end

    it 'should destroy comments when post is destroyed' do
      comments = @post.comments.to_a
      @post.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
  end
end
