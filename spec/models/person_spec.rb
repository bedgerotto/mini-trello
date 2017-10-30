require 'rails_helper'

RSpec.describe Person, type: :model do
  fixtures :all
  context 'Creates new Person' do
    it 'Empty person is not valid' do
      person = Person.new
      person.name = 'Person 1'
      expect(person.valid?).to be_falsy
    end
    it 'Person saves with required fields' do
      person = Person.new
      person.name = 'Person 1'
      person.role = 'Manager'
      person.email = 'manager@gmail.com'
      person.password = 'goodpass'
      expect(person.valid?).to be_truthy
    end
  end
end
