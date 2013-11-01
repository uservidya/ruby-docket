require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @user    = User.make!
    @project = Project.make!(team: @user.team)
  end

  test "should get index" do
    get :index
    assert_redirected_to new_user_session_path

    sign_in(@user)
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_redirected_to new_user_session_path

    sign_in(@user)
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_no_difference('Project.count') do
      post :create, project: { completed_at: @project.completed_at, due_date: @project.due_date, name: @project.name, team_id: @project.team_id }
    end
    assert_redirected_to new_user_session_path

    sign_in(@user)
    assert_difference('Project.count') do
      post :create, project: { completed_at: @project.completed_at, due_date: @project.due_date, name: @project.name, team_id: @project.team_id }
    end
    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_redirected_to new_user_session_path

    sign_in(@user)
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_redirected_to new_user_session_path

    sign_in @user
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { completed_at: @project.completed_at, due_date: @project.due_date, name: @project.name, team_id: @project.team_id }
    assert_redirected_to new_user_session_path

    sign_in @user
    patch :update, id: @project, project: { completed_at: @project.completed_at, due_date: @project.due_date, name: @project.name, team_id: @project.team_id }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_no_difference('Project.count') do
      delete :destroy, id: @project
    end
    assert_redirected_to new_user_session_path

    sign_in @user
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end
    assert_redirected_to projects_path
  end

  test 'should complete project' do
    post :complete, id: @project
    assert_redirected_to new_user_session_path

    sign_in @user
    post :complete, id: @project
    assert_response :redirect
    assert @project.reload.complete?
  end

  test 'should uncomplete project' do
    post :uncomplete, id: @project
    assert_redirected_to new_user_session_path

    sign_in @user
    post :uncomplete, id: @project
    assert_response :redirect
    assert @project.reload.incomplete?
  end
end
