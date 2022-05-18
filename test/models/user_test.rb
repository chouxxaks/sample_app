require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do         # 有効性の検証
    assert @user.valid?
  end
  
  test "name should be present" do  # nameの存在性の検証
    @user.name = "     "
    assert_not @user.valid?         # Userオブジェクトが無効になったことを確認する
  end
  
  test "email should be present" do # emailの存在性の検証
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do   # nameの長さの検証
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do  # emailの長さの検証
    @user.email = "a"*244+"@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do    # 有効なメールフォーマットを検証
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]  # 正しいアドレス
    valid_addresses.each do |valid_addresses|
      @user.email = valid_addresses
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do    # メールフォーマット（@がない、.が,になっている等）の検証
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com] # 正しくないアドレス
    invalid_addresses.each do |invalid_addresses|
      @user.email = invalid_addresses
      assert_not @user.valid?, "#{invalid_addresses.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do  # 重複したmailアドレスを拒否
    duplicate_user = @user.dup                # .dup：同じ属性を持つデータを複製するためのメソッド
    duplicate_user.email = @user.email.upcase # 大文字小文字を区別しない（メールアドレス）
    @user.save
    assert_not duplicate_user.valid?          # saveした後では、同じemailが既にDB内に存在するため、ユーザ作成は無効になる
  end
  
  test "email addresses should be saved as lower-case" do     # メールアドレスの大文字小文字を区別しない
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present (noblank)" do              # パスワードが空白でないことを検証
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should be habe a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do   # digestが存在しない場合の検証
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do                       # 関連するマイクロポストが破棄されることを検証
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
  
end
