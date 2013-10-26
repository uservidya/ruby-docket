class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :reporter, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  has_many :comments

  has_ancestry orphan_strategy: :restrict
end
