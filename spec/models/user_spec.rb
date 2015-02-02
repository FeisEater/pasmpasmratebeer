require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "can not be created without password" do
    user = User.create username:"Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "can not be created with a password just consisting of letters" do
    user = User.create username:"Pekka", password:"abcdefghijk", password_confirmation:"abcdefghijk"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "can not be created with a short password" do
    user = User.create username:"Pekka", password:"A1", password_confirmation:"A1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }
    
    it "is saved with a proper password" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
