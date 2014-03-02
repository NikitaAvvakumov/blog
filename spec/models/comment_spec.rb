require 'spec_helper'

describe Comment do

  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user) }

  before { @comment = post.comments.build(content: 'A new comment', author: 'Rando M. Commenter', email: 'rando@example.com') }

  subject { @comment }

  it { should respond_to :content }
  it { should respond_to :post_id }
  it { should respond_to :author }
  it { should respond_to :email }
  its(:post) { should eq post }
  it { should be_valid }

  describe 'validations' do
    context 'when content is absent' do
      before { @comment.content = '' }
      it { should_not be_valid }
    end

    context 'when post_id is missing' do
      before { @comment.post_id = nil }
      it { should_not be_valid }
    end

    context 'when author is missing' do
      before { @comment.author = '' }
      it { should_not be_valid }
    end
  end
end
