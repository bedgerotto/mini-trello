require 'rails_helper'

RSpec.describe History, type: :model do
  fixtures :all
  context 'Creates new History' do
    it 'Empty history is not valid' do
      history = History.new
      history.owner = Person.first
      history.requester = Person.first
      expect(history.valid?).to be_falsy
    end
    it 'History saves with required fields' do
      history = History.new
      history.owner = Person.first
      history.requester = Person.first
      history.project = Project.first
      history.status = 'pending',
      history.name = 'Test'
      expect(history.valid?).to be_truthy
    end
  end
end
