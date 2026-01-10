class Task < ApplicationRecord
  # Organization association
  belongs_to :organization, optional: true

  # Self-referential association for hierarchy
  belongs_to :parent, class_name: "Task", optional: true
  has_many :children, class_name: "Task", foreign_key: "parent_id", dependent: :destroy

  # User associations
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", optional: true

  # Tags
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  # Dependencies
  has_many :task_dependencies, dependent: :destroy
  has_many :dependencies, through: :task_dependencies, source: :dependency
  has_many :dependent_tasks, class_name: "TaskDependency", foreign_key: "dependency_id", dependent: :destroy
  has_many :dependents, through: :dependent_tasks, source: :task

  # Version history
  has_many :versions, class_name: "TaskVersion", dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :task_type, inclusion: { in: %w[strategy initiative epic task] }
  validates :status, inclusion: { in: %w[not_started in_progress completed blocked] }
  validates :default_view, inclusion: { in: %w[document kanban] }

  # Scopes
  scope :root_tasks, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_type, ->(type) { where(task_type: type) }

  # Constants
  TASK_TYPES = %w[strategy initiative epic task].freeze
  STATUSES = %w[not_started in_progress completed blocked].freeze
  VIEWS = %w[document kanban].freeze

  STATUS_LABELS = {
    "not_started" => "Not Started",
    "in_progress" => "In Progress",
    "completed" => "Completed",
    "blocked" => "Blocked"
  }.freeze

  TYPE_LABELS = {
    "strategy" => "Strategy",
    "initiative" => "Initiative",
    "epic" => "Epic",
    "task" => "Task"
  }.freeze

  # Callbacks
  after_save :create_version_if_content_changed

  # Get ancestors for breadcrumb
  def ancestors
    ancestors_list = []
    current = parent
    while current
      ancestors_list.unshift(current)
      current = current.parent
    end
    ancestors_list
  end

  # Get all descendants
  def descendants
    children.flat_map { |child| [ child ] + child.descendants }
  end

  # Check if this task can have children of a given type
  def allowed_child_types
    case task_type
    when "strategy" then %w[initiative]
    when "initiative" then %w[epic]
    when "epic" then %w[task]
    when "task" then []
    else TASK_TYPES
    end
  end

  # Create a new version snapshot
  def create_version!(user = nil)
    versions.create!(
      title: title,
      content: content,
      user: user
    )
  end

  # Restore from a version
  def restore_from_version!(version)
    update!(
      title: version.title,
      content: version.content
    )
  end

  # Status helpers
  def status_label
    STATUS_LABELS[status]
  end

  def type_label
    TYPE_LABELS[task_type]
  end

  private

  def create_version_if_content_changed
    return unless saved_change_to_content? || saved_change_to_title?
    return if versions.where(title: title, content: content).exists?

    create_version!(creator)
  end
end
