require 'spec_helper'

describe CommentsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { Topic.create(name: 'Code') }
  let(:post) { FactoryGirl.create(:post, user: user, topic: topic) }

  describe 'posting a comment' do

    it 'should increment the comment count'do
      expect do
        xhr :post, :create, comment: { name: 'Rando M. Commenter', content: 'This post is awesome!', post_id: post.id }
        # xhr HTTP method, action, params hash
      end.to change(Comment, :count).by(1)
    end

    it 'should respond with success' do
      xhr :post, :create, comment: { name: 'Rando M. Commenter', content: 'This post is awesome!', post_id: post.id }
      expect(response).to be_success
    end
  end

  describe 'deleting a comment' do
    let(:comment) { FactoryGirl.create(:comment, post: post) }
    before { sign_in user, no_capybara: true }

    it 'should decrement the comment count' do
      expect do
        xhr :delete, :destroy, id: comment.id
      end.to change(Comment, :count).by(-1)
    end

    it 'should respond with success' do
      xhr :delete, :destroy, id: comment.id
      expect(response).to be_success
    end
  end
end