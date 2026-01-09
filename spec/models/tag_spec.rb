require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it 'requires a name' do
      tag = build(:tag, name: nil)
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique name within an organization' do
      organization = create(:organization)
      create(:tag, name: 'urgent', organization: organization)
      tag = build(:tag, name: 'urgent', organization: organization)
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include('has already been taken')
    end

    it 'allows same name in different organizations' do
      org1 = create(:organization)
      org2 = create(:organization)
      create(:tag, name: 'urgent', organization: org1)
      tag = build(:tag, name: 'urgent', organization: org2)
      expect(tag).to be_valid
    end

    it 'validates color format' do
      tag = build(:tag, color: 'invalid')
      expect(tag).not_to be_valid
      expect(tag.errors[:color]).to include('is invalid')
    end

    it 'accepts valid hex colors' do
      tag = build(:tag, color: '#ff5733')
      expect(tag).to be_valid
    end

    it 'allows blank color' do
      tag = build(:tag, color: '')
      expect(tag).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an organization' do
      association = described_class.reflect_on_association(:organization)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many task_tags' do
      association = described_class.reflect_on_association(:task_tags)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'has many tasks through task_tags' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :task_tags
    end
  end

  describe 'callbacks' do
    it 'sets a default color if blank' do
      tag = create(:tag, color: nil)
      expect(tag.color).to be_present
      expect(Tag::COLORS).to include(tag.color)
    end
  end

  describe '#deletable?' do
    it 'returns true when tag has no tasks' do
      tag = create(:tag)
      expect(tag.deletable?).to be true
    end

    it 'returns true when tag has one task' do
      tag = create(:tag)
      task = create(:task)
      create(:task_tag, tag: tag, task: task)
      expect(tag.deletable?).to be true
    end

    it 'returns false when tag has more than one task' do
      tag = create(:tag)
      task1 = create(:task)
      task2 = create(:task)
      create(:task_tag, tag: tag, task: task1)
      create(:task_tag, tag: tag, task: task2)
      expect(tag.deletable?).to be false
    end
  end
end
