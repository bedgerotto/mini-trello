# ProjectController. This handles with requests and returns
# project data
class ProjectController < ApplicationController
  # Histories method that returns the histories from a project
  # separated by status
  def histories
    # return json of histories
    render json: History.find_histories_by_status(params[:id])
  end
end
