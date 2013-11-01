require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @team = Team.make!
    @old = Project.make!(team: @team, completed_at: Date.yesterday - 2.weeks)
    @done = Project.make!(team: @team, completed_at: Date.yesterday)
    @project = Project.make!(team: @team)
  end

  test 'scoped complete' do
    assert_equal [@old, @done], @team.projects.complete
  end

  test 'scoped incomplete' do
    assert_equal [@project], @team.projects.incomplete
  end

  test 'scoped recent' do
    assert_equal [@done], @team.projects.recent
    assert_equal [@old, @done], @team.projects.recent(30)
  end

  test 'completable?' do
    assert_equal true, @project.completable?

    1.upto(10) do
      Task.make!(project: @project, completed_at: nil)
    end
    @project.reload

    assert_equal false, @project.completable?

    @project.tasks.limit(5).update_all(completed_at: Time.now)
    @project.reload
    assert_equal false, @project.completable?

    @project.tasks.update_all(completed_at: Time.now)
    @project.reload
    assert_equal true, @project.completable?
  end

  test 'deletable?' do
    assert_equal true, @project.deletable?

    Task.make!(project: @project)
    @project.reload

    assert_equal false, @project.deletable?
  end

  test 'complete?' do
    assert_nil @project.completed_at
    assert_equal false, @project.complete?

    @project.completed_at = Time.now
    assert_equal true, @project.complete?
  end

  test 'incomplete?' do
    assert_equal true, @project.incomplete?

    @project.completed_at = Time.now
    assert_equal false, @project.incomplete?
  end

  test 'complete!' do
    assert_equal false, @project.complete?

    @project.complete!

    assert_equal true, @project.complete?
  end

  test 'uncomplete!' do
    assert_equal true, @done.complete?

    @done.uncomplete!

    assert_equal false, @done.complete?
  end

  test 'completion' do
    assert_equal 0.0, @project.completion

    t = Task.make(project: @project, estimate: nil)

    assert_equal 0.0, @project.completion

    t.update_attributes(estimate: 100)

    assert_equal 0.0, @project.reload.completion

    t.complete!
    assert_equal 1.0, @project.reload.completion
  end

  test 'team_users' do
    assert_equal @project.team.users, @project.team_users
  end

  test 'team_name' do
    assert_equal @project.team.name, @project.team_name
  end

  test 'formatted_completion' do
    Task.make!(project: @project, estimate: 1.0)
    Task.make!(project: @project, estimate: 1.0, completed_at: Time.now)
    assert_equal '50.0%', @project.reload.formatted_completion
  end

end
