require 'spec_helper'

describe "Post views" do

  subject { page }

  describe 'index view / homepage' do

    let(:user) { FactoryGirl.create(:user) }
    let(:topic) { Topic.new(name: 'Code') }
    let!(:older_post) { user.posts.create(title: 'An older post', body: 'This is an older blog post.---MORE---', topic: topic) }
    let!(:newer_post) { user.posts.create(title: 'A newer post', body: 'This is a newer blog post.---MORE---More text here.', topic: topic) }
    before { visit root_path }

    it { should have_title('The quoth blog.') }
    it { should have_selector('h1', text:'Welcome to the quoth blog.') }

    it { should have_selector('h2', text: older_post.title) }
    it { should have_content('This is an older blog post.') }
    it { should have_selector('h2', text: newer_post.title) }
    it { should have_content('This is a newer blog post.') }
    it { should_not have_content('---MORE---') }
    it { should_not have_content('More text here.') }

    it 'should display posts in reverse chronological order' do
      page.body.index('This is a newer blog post.').should < page.body.index('This is an older blog post.')
    end

    describe 'links' do

      describe 'post links should link to correct post' do
        before { click_link newer_post.title }

        it { should have_title newer_post.title }
      end

      describe 'new post link' do
        before do
          sign_in user
          visit root_path
          click_link 'Create a new post'
        end
        it { should have_title 'New post' }
      end
    end
  end

  describe 'individual post views' do
    let(:user) { FactoryGirl.create(:user) }
    let(:topic) { Topic.new(name: 'Code') }
    let(:post) { user.posts.create(title: 'A new post', body: 'This is a new blog post.---MORE---More text here.', topic: topic) }
    let!(:comment1) { post.comments.create(content: 'Lorem ipsum', author: 'Commenter One') }
    let!(:comment2) { post.comments.create(content: 'Dolor sit amet', author: 'Commenter Two') }

    describe 'as a visitor' do
      before { visit post_path(post) }

      it { should have_title post.title }
      it { should have_selector 'h2', text: post.title }
      it { should have_content 'This is a new blog post.' }
      it { should have_content 'More text here.' }
      it { should_not have_content '---MORE---' }
      it { should_not have_link 'Edit', href: edit_post_path(post) }
      it { should_not have_link 'Delete', href: post_path(post) }
      it { should have_link topic.name, href: topic_path(topic) }

      describe 'comments' do
        it { should have_content comment1.content }
        it { should have_content comment2.content }
        it { should have_content comment1.author }
        it { should have_content comment2.author }
        it { should have_content post.comments.count }
        it { should_not have_link "#{comment1}_delete" }
        it { should_not have_link "#{comment2}_delete" }
      end
    end

    describe 'as a signed-in user' do
      before do
        sign_in user
        visit post_path(post)
      end

      describe 'post' do
        it { should have_link 'Edit', href: edit_post_path(post) }
        it { should have_link 'Delete', href: post_path(post) }

        describe 'deleting the post' do
          it 'should delete the post' do
            expect { click_link 'Delete' }.to change(Post, :count).by(-1)
            expect(page).to have_title(full_title(''))
            expect(page).to have_selector 'div.alert.alert-success', text: 'Post deleted.'
          end
        end
      end

      describe 'comments' do
        it { should have_link "#{comment1.id}_delete" }
        it { should have_link "#{comment2.id}_delete" }

        describe 'deleting comments' do
          it 'should delete the comment' do
            expect { click_link "#{comment1.id}_delete" }.to change(Comment, :count).by(-1)
            expect(page).to have_title(full_title(post.title))
            expect(page).to have_selector 'div.alert.alert-success', text: 'Comment deleted.'
          end
        end
      end
    end
  end

  describe 'new post view' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:topic1) { Topic.create(name: 'Code') }
    let!(:topic2) { Topic.create(name: 'Design') }

    before do
      sign_in user
      visit new_post_path
    end

    it { should have_title 'New post' }
    it { should have_selector 'h1', text: 'Write an awesome new post' }
    it { should_not have_link 'Abandon changes' }

    describe 'new post creation' do

      describe 'with incomplete information' do
        it 'should not create a post' do
          expect { click_button 'Create post' }.not_to change(Post, :count)
        end

        describe 'error message' do
          before { click_button 'Create post' }
          it { should have_content 'problem' }
        end
      end

      describe 'with complete information' do
        before do
          fill_in 'Title', with: 'A new post'
          fill_in 'Body', with: 'This is a brand new blog post'
          choose 'post_topic_id_1'
        end

        it 'should create a new post' do
          expect { click_button 'Create post' }.to change(Post, :count).by(1)
        end

        describe 'it should redirect to the new post page' do
          before { click_button 'Create post' }
          it { should have_title(full_title('A new post')) }
          it { should have_selector 'div.alert.alert-success', text: 'Post created.' }
        end

      end
    end
  end

  describe 'edit post view' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:topic1) { Topic.create(name: 'Code') }
    let!(:topic2) { Topic.create(name: 'Design') }
    let(:post) { user.posts.create(title: 'A new post', body: 'This is a new blog post', topic: topic1) }
    before do
      sign_in user
      visit edit_post_path(post)
    end

    it { should have_title post.title }
    it 'should have the post title in text input' do
      expect(find_field('post_title').value).to eq post.title
    end
    it { should have_selector 'textarea', text: post.body }
    it { should have_link 'Abandon changes' }

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
          choose 'post_topic_id_2'
          click_button 'Update post'
        end

        it { should have_title(full_title('A new title')) }
        it { should have_content 'New body text.' }
        it { should have_content "This is an article on #{topic2.name}." }
        it { should have_selector 'div.alert.alert-success', text: 'The post was updated.'}
      end
    end
  end
end
