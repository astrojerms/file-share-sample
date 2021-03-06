require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "example", email: "user@example.com",
                     password: "foobar12", password_confirmation: "foobar12")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 41
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 245 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid emails" do
    invalid_addresses = %w[user@exampe,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+bax.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "password should be 8 characters or longer" do
    @user.password = @user.password_confirmation = "x" * 7
    assert_not @user.valid?
  end
end
