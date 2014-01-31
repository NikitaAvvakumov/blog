require 'spec_helper'

describe Post do
  before { @post = Post.new(title: 'A new post', body: 'This is a new blog post.') }

  subject { @post }

  it { should respond_to :title }
  it { should respond_to :body }
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
  end

  describe 'ordering' do
    let!(:older_post) { Post.create(title: 'Title', body: 'text', created_at: 1.day.ago) }
    let!(:newer_post) { Post.create(title: 'Title', body: 'text', created_at: 1.hour.ago) }

    it 'should arrange posts in reverse chronological order' do
      expect(Post.all.to_a).to eq [newer_post, older_post]
    end
  end
end
