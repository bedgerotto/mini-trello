class HistoryController < ApplicationController
    def store
        h = params[:history]
        history = History.new :name => h[:name], :description => h[:description], :deadline => h[:deadline], :owner_id => current_person.id, :project_id => params[:project_id], :points => h[:points], :requester_id => h[:requester_id], :status => 'pending'

        params[:tasks].each do |k|
            history.tasks.push(Task.new :description => k[:description], :done => false)
        end
        history.save
        render json: history.to_json(:include => [:tasks])
    end

    def update
        h = History.find_by :id => params[:id]
        
        h.update :name => params[:history][:name], :description => params[:history][:description], :deadline => params[:history][:deadline], :points => params[:history][:points], :requester_id => params[:history][:requester_id]

        h.tasks.delete_all
        params[:history][:tasks].each do |t|
           h.tasks.push(Task.new :description => t[:description], :done => t[:done]) 
        end
        h.save

        render json: h.to_json(:include => [:tasks])
    end

    def status
        h = History.find_by :id => params[:id]
        h.status = params[:status]
        if (params[:status] == 'started') && (h.started_at.nil?)
            h.started_at = DateTime.now.in_time_zone('Brasilia').to_time
        end
        h.save
        render json: h.errors.empty?
    end

    # Removes a history
    def destroy
        history = History.where(:id => params[:id])
        history.destroy(params[:id])
        
        render json: !history.exists?
    end

    def finish
        h = History.find_by :id => params[:id]
        updated = h.updated_at
        if !h.started_at.nil?
            h.finished_at = DateTime.now.in_time_zone('Brasilia').to_time
            h.save    
        end
        render json: updated != h.updated_at
    end
end
