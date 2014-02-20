require 'spec_helper'

describe User do

  before { @user = User.new(name: 'Nik', email: 'nik@quoth.com', bio: 'Nik is the back-end developer at quoth.',
                            password: 'something', password_confirmation: 'something') }

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :bio }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }
  it { should respond_to :remember_token }
  it { should respond_to :posts }
  it { should be_valid }

  describe 'validations' do

    context 'when name is missing' do
      before { @user.name = '' }
      it { should_not be_valid }
    end

    context 'when name is too long' do
      before { @user.name = 'a' * 26 }
      it { should_not be_valid }
    end

    context 'when email is missing' do
      before { @user.email = '' }
      it { should_not be_valid }
    end

    context 'when bio is missing' do
      before { @user.bio = '' }
      it { should_not be_valid }
    end

    context 'when password is missing' do
      before { @user.password = @user.password_confirmation = '' }
      it { should_not be_valid }
    end

    context 'when password is too short' do
      before { @user.password = @user.password_confirmation = 'a' * 7 }
      it { should_not be_valid }
    end

    context 'when confirmation does not match password' do
      before { @user.password = 'somethingelse' }
      it { should_not be_valid }
    end

    describe '.authenticate' do
      before { @user.save }
      let(:retrieved_user) { User.find_by(email: @user.email) }

      describe 'with valid password' do
        it { should eq retrieved_user.authenticate(@user.password) }
      end

      describe 'with invalid password' do
        let(:bad_password_user) { retrieved_user.authenticate('bad_password') }

        it { should_not eq bad_password_user }
        specify { expect(bad_password_user).to be_false }
      end
    end

    context 'when name is already taken' do
      before { duplicate_name_user = User.create(name: @user.name.upcase, email: 'user@quoth.com', bio: 'Blah blah blah',
                                                 password: 'something', password_confirmation: 'something') }

      it { should_not be_valid }
    end

    context 'when email is already taken' do
      before { duplicate_email_user = User.create(name: 'A new name', email: @user.email.upcase, bio: 'Blah blah blah',
                                                  password: 'something', password_confirmation: 'something') }

      it { should_not be_valid }
    end

    describe 'remember_token' do
      before { @user.save }
      its(:remember_token) { should_not be_blank }
    end
  end

  describe 'email should be saved as all lower-case' do
    before do
      @user.email.upcase!
      @user.save
    end
    specify { expect(@user.reload.email).to eq 'nik@quoth.com' }
  end

  describe 'associated posts' do
    before { @user.save }
    let!(:older_post) { FactoryGirl.create(:post, user: @user, created_at: 1.day.ago) }
    let!(:newer_post) { FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago) }

    it 'should arrange the posts in reverse chronological order' do
      expect(@user.posts.to_a).to eq [newer_post, older_post]
    end
  end
end
