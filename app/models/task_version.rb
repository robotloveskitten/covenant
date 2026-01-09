class TaskVersion < ApplicationRecord
  belongs_to :task
  belongs_to :user, optional: true

  validates :version_number, presence: true, uniqueness: { scope: :task_id }
  validates :title, presence: true

  before_validation :set_version_number, on: :create

  scope :ordered, -> { order(version_number: :desc) }

  private

  def set_version_number
    return if version_number.present?

    max_version = task&.versions&.maximum(:version_number) || 0
    self.version_number = max_version + 1
  end
end
