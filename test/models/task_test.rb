require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = tasks(:incomplete)
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
