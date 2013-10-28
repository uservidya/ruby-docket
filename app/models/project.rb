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

  def completable?
    tasks.all?(&:complete?)
  end

  def complete?
    !completed_at.nil?
  end

  def incomplete?
    !complete?
  end

  def uncomplete!
    update_attributes(completed_at: nil)
  end

  def complete!
    update_attributes(completed_at: Time.now)
  end

  def team_name(for_display = false)
    team.name
  end

  def team_users
    team.users
  end

  def completion
    total = tasks.map(&:weight).sum

    return 0.0 if total.zero? || total.nil?

    tasks.complete.map(&:weight).sum / total.to_f
  end

  def formatted_completion
    Formatter.format_percent(completion)
  end
end
