require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password is stored as a bcrypt hash" do
    user = User.create!(uid: "newuser", pass: BCrypt::Password.create("newpass"))
    user.reload
    assert_not_equal "newpass", user.pass
    assert BCrypt::Password.new(user.pass) == "newpass"
    assert_not BCrypt::Password.new(user.pass) == "wrong"
  end
end
