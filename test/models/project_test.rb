require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    @old = projects(:one)
    @done = projects(:done)
    @new = projects(:new)

    @project = projects(:new)
  end

  test 'complete?' do
    assert_nil @project.completed_at
    assert_equal false, @project.complete?

    @project.completed_at = Time.now
    assert_equal true, @project.complete?
  end

  test 'complete!' do
    assert_equal false, @project.complete?

    @project.complete!

    assert_equal true, @project.complete?
  end

  test 'uncomplete!' do
    project = projects(:one)

    assert_equal true, project.complete?

    project.uncomplete!

    assert_equal false, project.complete?
  end

  test 'completion' do
    assert_equal 0.0, @project.completion

    t = Task.create!(name: 'Foo', reporter: User.last,
                     project: @project, estimate: nil)

    assert_equal 0.0, @project.completion

    t.update_attributes(estimate: 100)

    assert_equal 0.0, @project.reload.completion

    t.complete!
    assert_equal 1.0, @project.reload.completion
  end

end
