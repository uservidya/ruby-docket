class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete, :uncomplete]
  before_filter :authenticate_user!

  # GET /projects
  def index
    @projects = current_user.projects
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.create(project_params)

    redirect_to @project, notice: 'Project was successfully created.'
  end
  # PUT /projects/1/uncomplete
  # PUT /projects/1/uncomplete.json
  def uncomplete
    @project.uncomplete!
    respond_to do |format|
      format.html { redirect_to request.referer||project_path(@project), notice: 'Project uncompleted successfully!' }
      format.json { head :no_content }
    end
  end

  # PUT /projects/1/complete
  # PUT /projects/1/complete.json
  def complete
    @project.complete!
    respond_to do |format|
      format.html { redirect_to request.referer||project_path(@project), notice: 'Project completed successfully!' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :due_date, :completed_at, :team_id)
    end
end
