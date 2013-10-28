class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :uncomplete]
  before_filter :authenticate_user!, :only => [:destroy, :update, :edit, :new, :create, :complete, :uncomplete]

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # PUT /tasks/1/uncomplete
  # PUT /tasks/1/uncomplete.json
  def uncomplete
    @task.uncomplete!
    respond_to do |format|
      format.html { redirect_to @task.project, notice: 'Task uncompleted successfully!' }
      format.json { head :no_content }
    end
  end

  # PUT /tasks/1/complete
  # PUT /tasks/1/complete.json
  def complete
    @task.complete!
    respond_to do |format|
      format.html { redirect_to @task.project, notice: 'Task completed successfully!' }
      format.json { head :no_content }
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:name, :body, :estimate, :completed_at, :project_id, :reporter_id, :owner_id)
    end
end
