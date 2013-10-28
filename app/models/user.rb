class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :team

  has_many :comments
  has_many :owned, class_name: 'Task', foreign_key: 'owner_id'
  has_many :reported, class_name: 'Task', foreign_key: 'reporter_id'

  def tasks
    owned + reported
  end

  def projects
    team.try(:projects) || []
  end
end
