require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do                             # マイクロポストが有効かどうか
    assert @micropost.valid?
  end

  test "user id should be present" do                   # ユーザーIDが存在しているか
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do                   # contentが存在しているか
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do    # 140字を超えていないか
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do           # DB上の最初のマイクロポストが、fixture内のマイクロポストと同じか
    assert_equal microposts(:most_recent), Micropost.first
  end
  
  
  
end
