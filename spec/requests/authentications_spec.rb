require 'spec_helper'

describe "Authentications" do

  subject { page }

  describe 'signin form' do
    before { visit root_path }

    it { should have_link 'Sign in', href: signin_path }

    describe 'signing in' do
      before { visit signin_path }

      it { should have_title 'Sign in' }
      it { should have_content 'Sign into the quoth blog' }
      it { should have_button 'Sign in' }

      describe 'with incomplete info' do
        before { click_button 'Sign in' }

        it { should have_title 'Sign in' }
        it { should have_selector 'div.alert.alert-warning', text: 'Invalid' }

        describe 'after giving up and going to another page' do
          before { click_link 'quoth blog' }

          it { should_not have_selector 'div.alert.alert-warning', text: 'Invalid' }
        end
      end

      describe 'with complete info' do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user } # defined in spec/support/utilities.rb

        it { should have_title(full_title(user.name)) }
        it { should have_content user.bio }
        it { should have_link 'Sign out', href: signout_path }
        it { should_not have_link 'Sign in', href: signin_path }
        it { should have_link 'Manage bloggers', href: users_path }
        it { should have_link 'Manage article topics', href: topics_path }
        it { should have_link 'My page', href: user_path(user) }

        describe 'followed by sign out' do
          before { click_link 'Sign out' }

          it { should have_title(full_title('')) }
          it { should have_link 'Sign in' }
          it { should_not have_link 'Sign out' }
        end
      end
    end
  end

  describe 'authorization' do

    describe 'in the Users controller' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'attempting to access the new user page while not signed in' do
        before { visit new_user_path }
        it { should have_title 'Sign in' }
      end

      describe 'attempting to issue a direct POST request while not signed in' do
        before { post users_path }
        specify { expect(response).to redirect_to signin_path }
      end

      describe 'attempting to access the user edit page while not signed in' do
        before { visit edit_user_path(user) }
        it { should have_title 'Sign in' }
      end

      describe 'attempting to issue a direct PATCH request while not signed in' do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to signin_path }
      end

      describe 'attempting to delete a user while not signed in' do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to signin_path }
      end

=begin
      describe 'as wrong user' do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, name: 'Wrong User', email: 'wrong@example.com') }
        before { sign_in user, no_capybara: true }

        describe 'attempting to edit another user info by issuing a direct get request' do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Edit')) }
          specify { expect(response).to redirect_to root_url }
        end

        describe 'attempting to update another user info by issuing a direct patch request' do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to root_url }
        end
      end
=end
    end

    describe 'in the Posts controller' do
      let(:user) { FactoryGirl.create(:user) }
      let(:post) { FactoryGirl.create(:post, user: user) }

      describe 'attempting to access the new post path without signing in' do
        before { visit new_post_path }
        it { should have_title 'Sign in' }
      end

      #describe 'attempting to issue a direct POST request while not signed in' do
      #  before { post posts_path }
      #  specify { expect(response).to redirect_to signin_path }
      #end

      describe 'attempting to access the post edit page while not signed in' do
        before { visit edit_post_path(post) }
        it { should have_title 'Sign in' }
      end

      describe 'attempting to issue a direct PATCH request while not signed in' do
        before { patch post_path(post) }
        specify { expect(response).to redirect_to signin_path }
      end

      describe 'attempting to delete a post while not signed in' do
        before { delete post_path(post) }
        specify { expect(response).to redirect_to signin_path }
      end
    end

    describe 'in the Comments controller' do
      let(:user) { FactoryGirl.create(:user) }
      let(:topic) { Topic.create(name: 'Code') }
      let(:post) { FactoryGirl.create(:post, user: user, topic: topic) }
      let(:comment) { FactoryGirl.create(:comment, post:post) }

      describe 'attempting to delete a post while not signed in' do
        before { delete post_comment_path(post, comment) }
        specify { expect(response).to redirect_to signin_path }
      end
    end
  end
end
