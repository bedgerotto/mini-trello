class HomeController < ApplicationController
    def index
        # List projects by name and id
        @people = Person.pluck(:name, :id)
    end
end
