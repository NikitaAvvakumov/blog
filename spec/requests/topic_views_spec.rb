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
end