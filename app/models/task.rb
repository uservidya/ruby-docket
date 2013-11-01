class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :reporter, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  has_many :comments

  has_ancestry orphan_strategy: :restrict

  validates :name, :reporter_id, :project_id, presence: true

  def self.incomplete
    where('tasks.completed_at IS NULL')
  end

  def project_users
    project.team.users
  end

  def owned?
    !owner_id.nil?
  end

  def complete?
    !completed_at.nil?
  end

  def incomplete?
    !complete?
  end

  def destroyable?
    children.empty?
  end

  def completable?
    children.empty? || children.all?(&:complete?)
  end

  def uncomplete!
    project.uncomplete! if project && project.complete?
    self.completed_at = nil
    self.save!
  end

  def complete!
    self.completed_at = Time.now
    self.save!
  end

  def formatted_body
    Formatter.format_markdown(body)
  end
end
