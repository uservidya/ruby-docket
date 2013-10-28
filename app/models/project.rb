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
    where('projects.completed_at >= ?', Date.today - window)
  end

  def completable?
    tasks.all?(&:complete?)
  end

  def deletable?
    tasks.empty?
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
    ts = tasks.map { |t| [t.complete?, t.estimate || 1.0] }
    total = ts.map {|t| t[1] }.sum
    complete = ts.map {|t| t[1] if t[0]}.compact.sum

    total.zero? || total.nil? ? 0.0 : complete/total.to_f
  end

  def formatted_completion
    Formatter.format_percent(completion)
  end
end
