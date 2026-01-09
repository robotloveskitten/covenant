require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'requires an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires a unique email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'requires a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'requires a password of at least 6 characters' do
      user = build(:user, password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'associations' do
    it 'has many assigned_tasks' do
      association = described_class.reflect_on_association(:assigned_tasks)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Task'
      expect(association.options[:foreign_key]).to eq 'assignee_id'
    end

    it 'has many created_tasks' do
      association = described_class.reflect_on_association(:created_tasks)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Task'
      expect(association.options[:foreign_key]).to eq 'creator_id'
    end
  end

  describe '#display_name' do
    it 'returns name when present' do
      user = build(:user, name: 'John Doe', email: 'john@example.com')
      expect(user.display_name).to eq 'John Doe'
    end

    it 'returns email prefix when name is blank' do
      user = build(:user, name: nil, email: 'john@example.com')
      expect(user.display_name).to eq 'john'
    end

    it 'returns email prefix when name is empty string' do
      user = build(:user, name: '', email: 'jane.doe@example.com')
      expect(user.display_name).to eq 'jane.doe'
    end
  end
end
