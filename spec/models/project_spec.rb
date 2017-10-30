require 'rails_helper'

RSpec.describe Project, type: :model do
  fixtures :all
  context 'Creates new Project' do
    it 'Empty project is not valid' do
      project = Project.new
      project.name = 'Project 1'
      expect(project.valid?).to be_falsy
    end
    it 'Project saves with required fields' do
      project = Project.new
      project.name = 'Test project'
      project.manager = Person.first
      expect(project.valid?).to be_truthy
    end
  end
end
