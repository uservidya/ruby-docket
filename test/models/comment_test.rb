require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test 'delete' do
    comment = comments(:one)

    comment.delete
    comment.save!
    comment.reload

    assert_not_nil comment.deleted_at
    assert_equal true, comment.deleted?
    assert_equal :deleted, comment.content
  end

  test 'undelete' do
    comment = comments(:deleted)

    comment.undelete
    comment.save!
    comment.reload

    assert_nil comment.deleted_at
    assert_equal false, comment.deleted?
    assert_equal 'body of the comment',
                 comment.content
  end

  test 'ancestry' do
    # Setup Test Data
    grandparent = comments(:grandparent)

    parent = comments(:parent)
    parent.parent = grandparent
    parent.save!

    child = comments(:child)
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
