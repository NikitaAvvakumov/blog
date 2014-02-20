require 'spec_helper'

describe Post do
  let(:user) { FactoryGirl.create(:user) }
  before { @post = user.posts.build(title: 'A new post', body: 'This is a new blog post.') }

  subject { @post }

  it { should respond_to :title }
  it { should respond_to :body }
  it { should respond_to :user_id }
  it { should respond_to :user }
  its(:user) { should eq user }
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

  describe 'ordering' do
    let(:user2) { FactoryGirl.create(:user, name: 'Unique Name', email: 'unique@quoth.com') }
    let!(:oldest_post) { user2.posts.create(title: 'Title', body: 'text', created_at: 1.year.ago) }
    let!(:older_post) { user.posts.create(title: 'Title', body: 'text', created_at: 1.day.ago) }
    let!(:newer_post) { user.posts.create(title: 'Title', body: 'text', created_at: 1.hour.ago) }

    it 'should arrange posts in reverse chronological order' do
      expect(Post.all.to_a).to eq [newer_post, older_post, oldest_post]
    end
  end
end
