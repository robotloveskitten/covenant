require 'rails_helper'

RSpec.describe TaskVersion, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      task = create(:task)
      task.versions.destroy_all
      version = build(:task_version, task: task, version_number: 1)
      expect(version).to be_valid
    end

    it 'requires a title' do
      version = build(:task_version, title: nil)
      expect(version).not_to be_valid
      expect(version.errors[:title]).to include("can't be blank")
    end

    it 'requires a unique version_number per task' do
      task = create(:task)
      task.versions.destroy_all
      create(:task_version, task: task, version_number: 1)
      duplicate = build(:task_version, task: task, version_number: 1)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:version_number]).to include('has already been taken')
    end

    it 'allows same version_number on different tasks' do
      task1 = create(:task)
      task2 = create(:task)
      task1.versions.destroy_all
      task2.versions.destroy_all

      create(:task_version, task: task1, version_number: 1)
      version2 = build(:task_version, task: task2, version_number: 1)
      expect(version2).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to task' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to user (optional)' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to be true
    end
  end

  describe 'callbacks' do
    it 'auto-increments version_number' do
      task = create(:task)
      task.versions.destroy_all

      version1 = create(:task_version, task: task, version_number: nil)
      version2 = create(:task_version, task: task, version_number: nil)

      expect(version1.version_number).to eq 1
      expect(version2.version_number).to eq 2
    end

    it 'does not override explicit version_number' do
      task = create(:task)
      task.versions.destroy_all

      version = create(:task_version, task: task, version_number: 10)
      expect(version.version_number).to eq 10
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns versions in descending order by version_number' do
        task = create(:task)
        task.versions.destroy_all

        v1 = create(:task_version, task: task, version_number: 1)
        v3 = create(:task_version, task: task, version_number: 3)
        v2 = create(:task_version, task: task, version_number: 2)

        expect(TaskVersion.ordered.to_a).to eq [v3, v2, v1]
      end
    end
  end
end
