class Team < ActiveRecord::Base
  has_many :users
  has_many :projects

  def user_names
    users.collect(&:name).join(', ')
  end
end
