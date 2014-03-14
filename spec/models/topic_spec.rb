require 'spec_helper'

describe Topic do
  before { @topic = Topic.new(name: 'Code') }

  subject { @topic }

  it { should respond_to :name }
  it { should respond_to :posts }
  it { should be_valid }

  describe 'validations' do

    context 'when name is missing' do
      before { @topic.name = '' }
      it { should_not be_valid }
    end

    context 'when name is already taken' do
      before { topic2 = Topic.create(name: 'Code') }
      it { should_not be_valid }
    end
  end
end
