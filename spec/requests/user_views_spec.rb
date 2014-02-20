require 'spec_helper'

describe "User views" do

  subject { page }

  describe 'new user view' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_user_path
    end

    it { should have_title 'Create a new blogger' }
    it { should have_content 'Create a new blogger' }

    describe 'user creation' do

      describe 'with invalid information' do

        it 'should not create a new user' do
          expect { click_button 'Add new blogger' }.not_to change(User, :count)
        end

        describe 'it should re-render the page with errors' do
          before { click_button 'Add new blogger' }

          it { should have_title 'Create a new blogger' }
          it { should have_selector 'div.alert.alert-warning', text: 'problem' }
        end
      end

      describe 'with valid information' do
        before do
          fill_in 'Name', with: 'New Blogger'
          fill_in 'Email', with: 'blogger@quoth.com'
          fill_in 'Password', with: 'something'
          fill_in 'Confirm password', with: 'something'
          fill_in 'Bio', with: 'An infinitely fascinating life story.'
        end

        it 'should create a new user' do
          expect { click_button 'Add new blogger' }.to change(User, :count).by(1)
        end

        describe 'it should show the new user page' do
          before { click_button 'Add new blogger' }

          it { should have_title(full_title('New Blogger')) }
          it { should have_selector 'div.alert.alert-success', text: 'New blogger created.' }
        end
      end
    end
  end

  describe 'show user view' do
    let(:user) { User.create(name: 'Nik', email: 'nik@quoth.com', bio: 'Nik is the back-end developer at quoth.',
                             password: 'something', password_confirmation: 'something') }
    before { visit user_path(user) }

    it { should have_title(full_title(user.name)) }
    it { should have_content user.name }
    it { should have_content user.bio }

    describe 'when not signed in' do
      it { should_not have_link "#{user.name}_edit" }
    end

    describe 'when signed in' do
      before do
        sign_in user
        visit user_path(user)
      end

      it { should have_link "#{user.name}_edit" }
    end
  end

  describe 'edit user view' do
    let(:user) { User.create(name: 'Nik', email: 'nik@quoth.com', bio: 'Nik is the back-end developer at quoth.',
                             password: 'something', password_confirmation: 'something') }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    it { should have_title "Edit #{user.name}" }
    it { should have_content "Edit info for #{user.name}" }
    it 'should have a text field with user name' do
      expect(find_field('user_name').value).to eq user.name
    end
    it 'should have a text field with user email' do
      expect(find_field('user_email').value).to eq user.email
    end
    it { should have_content 'Password' }
    it { should have_content 'Confirm password' }
    it { should have_selector 'textarea', text: user.bio }

    describe 'editing user info' do

      describe 'with complete info' do
        let(:new_name) { 'Des' }
        let(:new_email) { 'des@quoth.com' }
        let(:new_bio) { 'Des is the unending source of energy in the quoth offices.' }
        before do
          fill_in 'Name', with: new_name
          fill_in 'Email', with: new_email
          fill_in 'Bio', with: new_bio
          fill_in 'Password', with: user.password
          fill_in 'Confirm password', with: user.password
          click_button 'Update info'
        end

        it 'should show user page with updated info and success flash' do
          expect(page).to have_title(full_title('Des'))
          expect(page).to have_selector 'div.alert.alert-success', text: 'Blogger info updated.'
        end
        specify { expect(user.reload.name).to eq new_name }
        specify { expect(user.reload.email).to eq new_email }
        specify { expect(user.reload.bio).to eq new_bio }
      end

      describe 'with incomplete info' do
        before do
          fill_in 'Name', with: ''
          fill_in 'Bio', with: ''
          click_button 'Update info'
        end

        it 'should re-display edit page with a warning flash' do
          expect(page).to have_title 'Edit Nik'
          expect(page).to have_content 'problem'
        end
      end
    end
  end


  describe 'user index view' do
    let!(:user_one) { User.create(name: 'Nik', email: 'nik@quoth.com', bio: 'Nik is the back-end developer at quoth.',
                                  password: 'something', password_confirmation: 'something') }
    let!(:user_two) { User.create(name: 'Mari', email: 'mari@quoth.com', bio: 'Mari is the front-end developer at quoth.',
                                  password: 'something', password_confirmation: 'something') }
    before { visit users_path }

    it { should have_title(full_title('Bloggers')) }
    it { should have_content 'The quoth bloggers:' }
    it { should have_selector 'h2', text: user_one.name }
    it { should have_selector 'h2', text: user_two.name }

    describe 'when viewed by a visitor' do
      it { should_not have_link "#{user_one.name}_delete", href: user_path(user_one) }
      it { should_not have_link "#{user_one.name}_edit", href: edit_user_path(user_one) }
      it { should_not have_link "#{user_two.name}_delete", href: user_path(user_two) }
      it { should_not have_link "#{user_two.name}_edit", href: edit_user_path(user_two) }
    end

    describe 'when viewed by a blogger' do
      before do
        sign_in user_one
        visit users_path
      end

      it { should have_link "#{user_one.name}_delete", href: user_path(user_one) }
      it { should have_link "#{user_one.name}_edit", href: edit_user_path(user_one) }
      it { should have_link "#{user_two.name}_delete", href: user_path(user_two) }
      it { should have_link "#{user_two.name}_edit", href: edit_user_path(user_two) }

      describe 'deleting users' do

        it 'should delete user'do
          expect { click_link("#{user_one.name}_delete") }.to change(User, :count).by(-1)
        end

        describe 'it should show index view with flash confirmation' do
          before { click_link("#{user_one.name}_delete") }

          it { should have_title(full_title('Bloggers')) }
          it { should have_selector 'div.alert.alert-success', text: 'Blogger has been deleted.' }
        end
      end
    end
  end
end
