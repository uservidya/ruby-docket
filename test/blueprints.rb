require 'machinist/active_record'
require 'securerandom'

Comment.blueprint do
  body { Faker::Lorem.paragraph }
  task { Task.make! }
  user { User.make!(team: object.task.project.team) }
end

User.blueprint do
  name { Faker::Name.name }
  team { Team.make! }
  email { Faker::Internet.email }
  password { SecureRandom.hex(32) }
end

Task.blueprint do
  name { Faker::Company.name }
  project { Project.make! }
  reporter { User.make!(team: object.project.team) }
end

Project.blueprint do
  name { Faker::Company.catch_phrase }
  team { Team.make! }
end

Team.blueprint do
  name { Faker::Lorem.word }
end
