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
end
