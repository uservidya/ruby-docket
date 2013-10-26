require 'test_helper'

class TaskTest < ActiveSupport::TestCase

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
