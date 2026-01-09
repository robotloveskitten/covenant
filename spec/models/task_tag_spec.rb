require 'rails_helper'

RSpec.describe TaskTag, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task_tag = build(:task_tag)
      expect(task_tag).to be_valid
    end

    it 'requires uniqueness of task_id scoped to tag_id' do
      task = create(:task)
      tag = create(:tag)
      create(:task_tag, task: task, tag: tag)

      duplicate = build(:task_tag, task: task, tag: tag)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:task_id]).to include('has already been taken')
    end

    it 'allows same tag on different tasks' do
      tag = create(:tag)
      task1 = create(:task)
      task2 = create(:task)

      create(:task_tag, task: task1, tag: tag)
      task_tag2 = build(:task_tag, task: task2, tag: tag)
      expect(task_tag2).to be_valid
    end

    it 'allows same task with different tags' do
      task = create(:task)
      tag1 = create(:tag)
      tag2 = create(:tag)

      create(:task_tag, task: task, tag: tag1)
      task_tag2 = build(:task_tag, task: task, tag: tag2)
      expect(task_tag2).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to task' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to tag' do
      association = described_class.reflect_on_association(:tag)
      expect(association.macro).to eq :belongs_to
    end
  end
end
