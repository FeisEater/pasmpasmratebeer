require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "can not be created without password" do
    user = User.new username:"Pekka"
    expect(user).not_to be_valid
  end
end
