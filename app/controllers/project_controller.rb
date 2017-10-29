# ProjectController. This handles with requests and returns
# project data
class ProjectController < ApplicationController
  # Histories method that returns the histories from a project
  # separated by status
  def histories
    # return json of histories
    render json: History.find_histories_by_status(params[:id])
  end

  # Store new project
  def store
    # try to create the new project
    project = Project.create(name: params[:name], manager_id: current_person.id)
    # returns the project object and possible errors messages
    render json: {project: project, errors: project.errors}
  end

  # Get list of projects
  def get
    render json: Project.select(:id, "name as label")
  end

  # Update project data
  def update
    # update project
    project = Project.update(params[:id], :name => params[:name])

    # returns if the data is updated
    render json: project.errors.empty?
  end

  # Removes a project
  def destroy
    project = Project.where(:id => params[:id])
    project.destroy(params[:id])
    
    render json: !project.exists?
  end
end
