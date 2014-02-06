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
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        it { should have_title(full_title(user.name)) }
        it { should have_content user.bio }
        it { should have_link 'Sign out', href: signout_path }
        it { should_not have_link 'Sign in', href: signin_path }
        it { should have_link 'All bloggers', href: users_path }
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
end
