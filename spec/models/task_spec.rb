require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'requires a title' do
      task = build(:task, title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'requires a valid task_type' do
      task = build(:task, task_type: 'invalid')
      expect(task).not_to be_valid
      expect(task.errors[:task_type]).to include('is not included in the list')
    end

    it 'requires a valid status' do
      task = build(:task, status: 'invalid')
      expect(task).not_to be_valid
      expect(task.errors[:status]).to include('is not included in the list')
    end

    it 'requires a valid default_view' do
      task = build(:task, default_view: 'invalid')
      expect(task).not_to be_valid
      expect(task.errors[:default_view]).to include('is not included in the list')
    end

    it 'accepts all valid task types' do
      Task::TASK_TYPES.each do |type|
        task = build(:task, task_type: type)
        expect(task).to be_valid
      end
    end

    it 'accepts all valid statuses' do
      Task::STATUSES.each do |status|
        task = build(:task, status: status)
        expect(task).to be_valid
      end
    end

    it 'accepts all valid views' do
      Task::VIEWS.each do |view|
        task = build(:task, default_view: view)
        expect(task).to be_valid
      end
    end
  end

  describe 'associations' do
    it 'belongs to parent (optional)' do
      association = described_class.reflect_on_association(:parent)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'has many children' do
      association = described_class.reflect_on_association(:children)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it 'belongs to assignee (optional)' do
      association = described_class.reflect_on_association(:assignee)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'belongs to creator (optional)' do
      association = described_class.reflect_on_association(:creator)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end

    it 'has many tags through task_tags' do
      association = described_class.reflect_on_association(:tags)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :task_tags
    end

    it 'has many dependencies' do
      association = described_class.reflect_on_association(:dependencies)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :task_dependencies
    end

    it 'has many versions' do
      association = described_class.reflect_on_association(:versions)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'scopes' do
    describe '.root_tasks' do
      it 'returns tasks without parents' do
        root = create(:task, parent: nil)
        child = create(:task, parent: root)
        expect(Task.root_tasks).to include(root)
        expect(Task.root_tasks).not_to include(child)
      end
    end

    describe '.by_status' do
      it 'returns tasks with specified status' do
        in_progress = create(:task, :in_progress)
        completed = create(:task, :completed)
        expect(Task.by_status('in_progress')).to include(in_progress)
        expect(Task.by_status('in_progress')).not_to include(completed)
      end
    end

    describe '.by_type' do
      it 'returns tasks with specified type' do
        strategy = create(:task, :strategy)
        task = create(:task)
        expect(Task.by_type('strategy')).to include(strategy)
        expect(Task.by_type('strategy')).not_to include(task)
      end
    end
  end

  describe '#ancestors' do
    it 'returns empty array for root tasks' do
      task = create(:task)
      expect(task.ancestors).to eq []
    end

    it 'returns parent chain in order' do
      grandparent = create(:task, :strategy)
      parent = create(:task, :initiative, parent: grandparent)
      child = create(:task, :epic, parent: parent)
      expect(child.ancestors).to eq [grandparent, parent]
    end
  end

  describe '#descendants' do
    it 'returns empty array for leaf tasks' do
      task = create(:task)
      expect(task.descendants).to eq []
    end

    it 'returns all descendants' do
      parent = create(:task, :epic)
      child1 = create(:task, parent: parent)
      child2 = create(:task, parent: parent)
      expect(parent.descendants).to match_array([child1, child2])
    end
  end

  describe '#allowed_child_types' do
    it 'allows initiatives for strategy' do
      task = build(:task, :strategy)
      expect(task.allowed_child_types).to eq %w[initiative]
    end

    it 'allows epics for initiative' do
      task = build(:task, :initiative)
      expect(task.allowed_child_types).to eq %w[epic]
    end

    it 'allows tasks for epic' do
      task = build(:task, :epic)
      expect(task.allowed_child_types).to eq %w[task]
    end

    it 'allows no children for task' do
      task = build(:task)
      expect(task.allowed_child_types).to eq []
    end
  end

  describe '#status_label' do
    it 'returns human-readable status' do
      task = build(:task, status: 'in_progress')
      expect(task.status_label).to eq 'In Progress'
    end
  end

  describe '#type_label' do
    it 'returns human-readable type' do
      task = build(:task, task_type: 'initiative')
      expect(task.type_label).to eq 'Initiative'
    end
  end

  describe 'version creation' do
    it 'creates a version when content changes' do
      task = create(:task, content: 'Original content')
      expect {
        task.update!(content: 'New content')
      }.to change { task.versions.count }.by(1)
    end

    it 'creates a version when title changes' do
      task = create(:task, title: 'Original title')
      expect {
        task.update!(title: 'New title')
      }.to change { task.versions.count }.by(1)
    end

    it 'does not create duplicate versions' do
      task = create(:task, title: 'Test', content: 'Content')
      task.update!(title: 'Test', content: 'Content')
      expect(task.versions.count).to eq 1
    end
  end

  describe '#create_version!' do
    it 'creates a version with current title and content' do
      task = create(:task, title: 'My Title', content: 'My Content')
      task.versions.destroy_all

      version = task.create_version!
      expect(version.title).to eq 'My Title'
      expect(version.content).to eq 'My Content'
    end
  end

  describe '#restore_from_version!' do
    it 'restores task from a version' do
      task = create(:task, title: 'Current', content: 'Current content')
      version = task.versions.create!(
        title: 'Old Title',
        content: 'Old content',
        version_number: 99
      )

      task.restore_from_version!(version)
      expect(task.reload.title).to eq 'Old Title'
      expect(task.content).to eq 'Old content'
    end
  end
end
