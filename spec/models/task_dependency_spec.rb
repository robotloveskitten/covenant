require 'rails_helper'

RSpec.describe TaskDependency, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task = create(:task)
      dependency = create(:task)
      task_dependency = build(:task_dependency, task: task, dependency: dependency)
      expect(task_dependency).to be_valid
    end

    it 'requires uniqueness of task_id scoped to dependency_id' do
      task = create(:task)
      dependency = create(:task)
      create(:task_dependency, task: task, dependency: dependency)

      duplicate = build(:task_dependency, task: task, dependency: dependency)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:task_id]).to include('has already been taken')
    end

    it 'prevents self-dependency' do
      task = create(:task)
      task_dependency = build(:task_dependency, task: task, dependency: task)
      expect(task_dependency).not_to be_valid
      expect(task_dependency.errors[:dependency]).to include("can't be the same as the task")
    end

    it 'prevents circular dependencies' do
      task_a = create(:task)
      task_b = create(:task)

      # A depends on B
      create(:task_dependency, task: task_a, dependency: task_b)

      # B depending on A would create a circular dependency
      circular = build(:task_dependency, task: task_b, dependency: task_a)
      expect(circular).not_to be_valid
      expect(circular.errors[:dependency]).to include('would create a circular dependency')
    end
  end

  describe 'associations' do
    it 'belongs to task' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to dependency' do
      association = described_class.reflect_on_association(:dependency)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:class_name]).to eq 'Task'
    end
  end
end
