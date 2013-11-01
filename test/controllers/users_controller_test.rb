require 'test_helper'
require 'securerandom'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    sign_out @user

    assert_difference('User.count') do
      post :create, {user: { name: 'Foo', email: Faker::Internet.email, password: SecureRandom.hex(14), team_id: Team.last.id }}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    # happy path
    patch :update, id: @user, user: { name: @user.name, team_id: @user.team_id }
    assert_redirected_to user_path(assigns(:user))

    # FIXME unhappy path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
