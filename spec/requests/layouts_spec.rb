require 'spec_helper'

describe "Layouts" do

  subject { page }

  describe 'page titles' do
    let(:post) { Post.create(title: 'A new post', body: 'A new blog post.') }
    it 'should generate correct page titles' do
      visit root_path
      it { should have_title(full_title('')) }
      visit new_post_path
      it { should have_title(full_title('New post')) }
      visit post_path(post)
      it { should have_title(full_title(post.title)) }
    end
  end
end
