require 'spec_helper'

describe 'Comment views' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:post) { user.posts.create(title: 'A new post', body: 'This is a new blog post.---MORE---More text here.') }

  describe 'writing a comment' do
    before { visit post_path(post) }

    describe 'with incomplete info' do

      it 'should not create a comment' do
        expect { click_button 'Post your comment'}.not_to change(Comment, :count)
      end

      describe 'error message' do
        before { click_button 'Post your comment' }
        it { should have_content 'problem' }
      end
    end

    describe 'with complete info' do
      before do
        fill_in 'comment_author', with: 'Rando M. Commenter'
        fill_in 'comment_email', with: 'rando@example.com'
        fill_in 'comment_content', with: 'What a well thought-out article. Kudos!'
      end

      it 'should create a new comment' do
        expect { click_button 'Post your comment' }.to change(Comment, :count).by(1)
      end

      describe 'success message' do
        before { click_button 'Post your comment' }
        it { should have_selector 'div.alert.alert-success', text: 'Your comment has been posted.' }
      end
    end
  end
end