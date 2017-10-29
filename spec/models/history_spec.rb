require 'rails_helper'

RSpec.describe History, type: :model do
  fixtures :histories
  context 'Creates new History' do
    it 'Empty history is not valid' do
      history = History.new
      expect(history.valid?).to be_falsy
    end
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
