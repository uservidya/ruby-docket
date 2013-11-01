require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = Team.make!
    @user_1 = User.make!(name: 'Foo', team: @team)
    @user_2 = User.make!(name: 'Bar', team: @team)
  end

  test 'user_names' do
    assert_equal 'Foo, Bar', @team.user_names
  end
end
