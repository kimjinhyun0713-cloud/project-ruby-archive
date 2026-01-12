class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]  
  # GET /projects or /projects.json
  def index
    set_tag_search_data(Project)
    @projects = @items
  end

  def show

  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :content, content_figures: [])
    end
end
