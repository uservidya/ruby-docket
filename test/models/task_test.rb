require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  setup do
    @project = Project.make!
    @task = Task.make!(project: @project)
  end

  test 'scoped incomplete' do
    new = Task.make!(project: @project, completed_at: Time.now)

    assert_equal [@task], @project.tasks.incomplete

    new.update_attributes(completed_at: nil)
    @project.reload

    assert_equal [@task, new], @project.tasks.incomplete
  end

  test 'project_users' do
    assert_equal @project.team.users, @task.project_users
  end

  test 'formatted_body' do
    @task.update_attributes(body: '# the body!')
    assert_equal '<h1>the body!</h1>', @task.formatted_body.chomp
  end

  test 'owned?' do
    assert_equal false, @task.owned?

    @task.update_attributes(owner_id: @task.reporter_id)
    @task.reload

    assert_equal true, @task.owned?
  end

  test 'complete?' do
    assert_nil @task.completed_at
    assert_equal false, @task.complete?

    @task.completed_at = Time.now
    assert_equal true, @task.complete?
  end

  test 'destroyable?' do
    Task.create!(name: 'FooTask', project_id: @task.project_id,
                 reporter_id: User.last.id, parent: @task)
    assert_equal false, @task.reload.destroyable?
  end

  test 'completable?' do
    assert_equal true, @task.completable?

    subtask = Task.create!(name: 'FooTask', project_id: @task.project_id,
                           reporter_id: User.last.id, parent: @task)
    assert_equal false, @task.reload.completable?

    subtask.completed_at = Time.now
    subtask.save!
    assert_equal true, @task.reload.completable?
  end

  test 'complete!' do
    assert_equal false, @task.complete?

    @task.complete!

    assert_equal true, @task.complete?
  end

  test 'uncomplete!' do
    task = tasks(:one)
    task.project = projects(:one)

    assert_equal true, task.complete?

    task.uncomplete!

    assert_equal false, task.complete?
    assert_equal false, task.project.complete?
  end

  test 'ancestry' do
    # Setup Test Data
    grandparent = tasks(:grandparent)

    parent = tasks(:parent)
    parent.parent = grandparent
    parent.save!

    child = tasks(:child)
    child.parent = parent
    child.save!

    # Test ancestral relations
    assert_equal [], grandparent.ancestors
    assert_equal [grandparent], parent.ancestors
    assert_equal [grandparent, parent], child.ancestors

    # Test basic depth calculation
    [grandparent, parent, child].each_with_index do |node, idx|
      assert_equal idx, node.depth
    end

  end

end
