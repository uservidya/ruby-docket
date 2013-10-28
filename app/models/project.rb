class Project < ActiveRecord::Base
  belongs_to :team
  has_many :tasks
  def self.incomplete
    where('completed_at IS NULL')
  end

  def self.complete
    where('completed_at IS NOT NULL')
  end

  def self.recent(window = 7)
    where('projects.created_at >= ?', Date.today - window)
  end
end
