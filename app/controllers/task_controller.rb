class TaskController < ApplicationController
    def done
        task = Task.find_by :id => params[:id]
        task.done = !task.done
        task.save
        render json: task.errors.empty?
    end
end
