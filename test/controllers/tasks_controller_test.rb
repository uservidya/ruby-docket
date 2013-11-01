require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @user = User.make!
    @task = Task.make!(reporter: @user)
    @proj = Project.make!(team: @user.team)
  end

  test "should get index" do
    get :index
    assert_redirected_to new_user_session_path

    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_redirected_to new_user_session_path

    sign_in @user
    get :new, task: {parent_id: nil, project_id: @proj.id}
    assert_response :success
  end

  test "should create task" do
    assert_no_difference('Task.count') do
      post :create, task: { body: @task.body, completed_at: @task.completed_at, estimate: @task.estimate, name: @task.name, owner_id: @task.owner_id, project_id: @task.project_id, reporter_id: @task.reporter_id }
    end
    assert_redirected_to new_user_session_path

    sign_in @user
    assert_difference('Task.count') do
      post :create, task: { body: @task.body, completed_at: @task.completed_at, estimate: @task.estimate, name: @task.name, owner_id: @task.owner_id, project_id: @task.project_id, reporter_id: @task.reporter_id }
    end
    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_redirected_to new_user_session_path

    sign_in @user
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_redirected_to new_user_session_path

    sign_in @user
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { body: @task.body, completed_at: @task.completed_at, estimate: @task.estimate, name: @task.name, owner_id: @task.owner_id, project_id: @task.project_id, reporter_id: @task.reporter_id }
    assert_redirected_to new_user_session_path

    sign_in @user
    patch :update, id: @task, task: { body: @task.body, completed_at: @task.completed_at, estimate: @task.estimate, name: @task.name, owner_id: @task.owner_id, project_id: @task.project_id, reporter_id: @task.reporter_id }
    assert_redirected_to task_path(assigns(:task))
  end

  test 'should complete task' do
    post :complete, id: @task
    assert_redirected_to new_user_session_path

    sign_in @user
    post :complete, id: @task
    assert @task.reload.complete?
    assert_redirected_to project_path(@task.project)
  end

  test 'should uncomplete task' do
    post :uncomplete, id: @task
    assert_redirected_to new_user_session_path

    sign_in @user
    post :uncomplete, id: @task
    assert @task.reload.incomplete?
    assert_redirected_to project_path(@task.project)
  end

  test "should destroy task" do
    assert_no_difference('Task.count') do
      request.env["HTTP_REFERER"] = tasks_path
      delete :destroy, id: @task
    end
    assert_redirected_to new_user_session_path

    sign_in @user
    assert_difference('Task.count', -1) do
      request.env["HTTP_REFERER"] = tasks_path
      delete :destroy, id: @task
    end
    assert_redirected_to tasks_path
  end
end
