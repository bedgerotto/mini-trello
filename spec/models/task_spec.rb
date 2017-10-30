require 'rails_helper'

RSpec.describe Task, type: :model do
  fixtures :all
  context 'Creates new Task' do
    it 'Empty task is not valid' do
      task = Task.new
      expect(task.valid?).to be_falsy
    end
    it 'Task saves with required fields' do
      task = Task.new
      task.description = 'Test task'
      task.history = History.first
      expect(task.valid?).to be_truthy
    end
  end
end
