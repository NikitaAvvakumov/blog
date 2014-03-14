require 'spec_helper'

describe "Topic views" do

  subject { page }

  describe 'show' do
    let(:topic) { Topic.create(name: 'Code') }
    let!(:post1) { Post.create(title: 'A new post', body: 'Some text here ---MORE--- and more there.',
                              user: FactoryGirl.create(:user), topic: topic) }
    before { visit topic_path(topic) }

    it { should have_title topic.name }
    it { should have_content "the quoth blog: #{topic.name}" }
    it { should have_selector 'h2', text: post1.title }
    it { should have_content 'Some text here' }
    it { should_not have_content 'and more there.' }
  end

  describe 'new' do
    before { visit new_topic_path }

    describe 'with invalid information' do

      context 'when topic name is missing' do
        it 'should not create a new topic' do
          expect { click_button 'Create new topic' }.not_to change(Topic, :count)
        end

        describe 'error message' do
          before { click_button 'Create new topic' }
          it { should have_selector 'div.alert.alert-warning' }
        end
      end

      context 'when topic name is duplicated' do
        let!(:existing_topic) { Topic.create(name: 'Code') }
        before { fill_in 'Topic name', with: 'Code' }
        it 'should not create a new topic' do
          expect { click_button 'Create new topic' }.not_to change(Topic, :count)
        end
      end
    end

    describe 'with valid information' do
      before { fill_in 'Topic name', with: 'Code' }
      it 'should create a new topic' do
        expect { click_button 'Create new topic' }.to change(Topic, :count).by(1)
      end
    end
  end

  describe 'index' do
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user, name: 'Jimmy', email: 'jimmy@example.com') }
    let!(:topic1) { Topic.create(name: 'Code') }
    let!(:topic2) { Topic.create(name: 'Design') }
    let!(:post1) { FactoryGirl.create(:post, user: user1, topic: topic1) }
    let!(:post2) { FactoryGirl.create(:post, user: user2, topic: topic2) }

    before { visit topics_path }

    it { should have_title 'Topics' }
    it { should have_link topic1.name, href: topic_path(topic1) }
    it { should have_link topic2.name, href: topic_path(topic2) }
    it { should have_content "1 article on this topic written by #{user1.name}" }
    it { should have_content "1 article on this topic written by #{user2.name}" }

    describe 'for visitors' do
      it { should_not have_link "#{topic1.name}_edit", href: edit_topic_path(topic1) }
      it { should_not have_link "#{topic1.name}_delete", href: topic_path(topic1) }
    end

    describe 'for signed-in bloggers' do
      before do
        sign_in user1
        visit topics_path
      end

      it { should have_link "#{topic1.name}_edit", href: edit_topic_path(topic1) }
      it { should have_link "#{topic1.name}_delete", href: topic_path(topic1) }

      describe 'deleting topics' do

        it 'should delete a topic when its link is clicked' do
          expect { click_link "#{topic1.name}_delete" }.to change(Topic, :count).by(-1)
        end

        describe 'redirect to the topic index page' do
          before { click_link "#{topic1.name}_delete" }
          it { should have_title 'Topics' }
        end
      end
    end
  end

  describe 'edit' do
    let(:topic) { Topic.create(name: 'Code') }
    before do
      sign_in FactoryGirl.create(:user)
      visit edit_topic_path(topic)
    end

    it { should have_title "Edit #{topic.name}" }
    it 'should have the topic name in text input' do
      expect(find_field('topic_name').value).to eq topic.name
    end

    describe 'updating the topic' do

      context 'when the name is missing' do
        before do
          fill_in 'Topic name', with: ''
          click_button 'Update topic name'
        end

        it { should have_content 'problem' }
      end

      context 'with valid info' do
        before do
          fill_in 'Topic name', with: 'Design'
          click_button 'Update topic name'
        end

        it { should have_title 'Topics' }
        it { should have_selector 'div.alert.alert-success' }
        it { should have_content 'Design' }
      end
    end
  end
end