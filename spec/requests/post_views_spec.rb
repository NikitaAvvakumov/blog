require 'spec_helper'

describe "Post views" do

  subject { page }

  describe 'index view / homepage' do
    let!(:older_post) { Post.create(title: 'An older post', body: 'This is an older blog post.') }
    let!(:newer_post) { Post.create(title: 'A newer post', body: 'This is a newer blog post.') }
    before { visit root_path }

    it { should have_title('The quoth blog.') }
    it { should have_selector('h1', text:'Welcome to the quoth blog.') }

    it { should have_selector('h2', text: older_post.title) }
    it { should have_content(older_post.body) }
    it { should have_selector('h2', text: newer_post.title) }
    it { should have_content(newer_post.body) }

    it 'should display posts in reverse chronological order' do
      page.body.index(newer_post.body).should < page.body.index(older_post.body)
    end

    describe 'links' do

      describe 'post links should link to correct post' do
        before { click_link newer_post.title }

        it { should have_title newer_post.title }
      end

      describe 'new post link' do
        before { click_link 'New post' }
        it { should have_title 'New post' }
      end
    end
  end

  describe 'individual post views' do
    let(:post) { Post.create(title: 'A new post', body: 'This is a new blog post') }
    before { visit post_path(post) }

    it { should have_title post.title }
    it { should have_selector 'h1', text: post.title }
    it { should have_content post.body }
  end

  describe 'new post view' do
    before { visit new_post_path }

    it { should have_title 'New post' }
    it { should have_selector 'h1', text: 'Write an awesome new post' }

    describe 'new post creation' do

      describe 'with incomplete information' do
        it 'should not create a post' do
          expect { click_button 'Create post' }.not_to change(Post, :count)
        end
      end

      describe 'with complete information' do
        before do
          fill_in 'Title', with: 'A new post'
          fill_in 'Body', with: 'This is a brand new blog post'
        end

        it 'should create a new post' do
          expect { click_button 'Create post' }.to change(Post, :count).by(1)
        end

        describe 'it should redirect to the new post page' do
          before { click_button 'Create post' }
          it { should have_title(full_title('A new post')) }
        end

      end
    end
  end

  describe 'edit post view' do
    let(:post) { Post.create(title: 'A new post', body: 'This is a new blog post') }
    before { visit edit_post_path(post) }

    it { should have_title post.title }
    it 'should have the post title in text input' do
      expect(find_field('post_title').value).to eq post.title
    end
    it { should have_selector 'textarea', text: post.body }

    describe 'updating the post' do
      describe 'with incomplete information' do

        context 'when title is missing' do
          before do
            fill_in 'Title', with: ''
            click_button 'Update post'
          end
          it { should have_content 'problem' }
        end

        context 'when body is missing' do
          before do
            fill_in 'Body', with: ''
            click_button 'Update post'
          end

          it { should have_selector 'div.alert.alert-warning' }
        end
      end

      describe 'with complete information' do
        before do
          fill_in 'Title', with: 'A new title'
          fill_in 'Body', with: 'New body text.'
          click_button 'Update post'
        end

        it { should have_title(full_title('A new title')) }
        it { should have_content 'New body text.' }
        it { should have_selector 'div.alert.alert-success', text: 'The post was updated.'}
      end
    end
  end
end
