class HomeController < ApplicationController
    def index
        # List projects by name and id
        @projects = Project.pluck(:name, :id)
    end
end
