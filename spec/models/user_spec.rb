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
  
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user)}
    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end
    
    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)    
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)
      
      expect(user.favorite_beer).to eq(beer)
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)
      
      expect(user.favorite_beer).to eq(best)
    end
    
  end
  
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user)}
    
    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end
    
    it "without ratings does not have favorite_style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "with one rating, that beer has the favorite style" do
      style = FactoryGirl.create(:style)
      create_beer_with_style_and_rating(10, style, user)
      expect(user.favorite_style).to eq(style)
    end
    
    it "is the one with best average rating" do
      style1 = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style)
      style3 = FactoryGirl.create(:style)
      create_beer_with_style_and_rating(1, style1, user)
      create_beer_with_style_and_rating(1, style1, user)
      create_beer_with_style_and_rating(1, style1, user)
      create_beer_with_style_and_rating(10, style2, user)
      create_beer_with_style_and_rating(1, style2, user)
      create_beer_with_style_and_rating(1, style2, user)
      create_beer_with_style_and_rating(5, style3, user)
      create_beer_with_style_and_rating(5, style3, user)
      create_beer_with_style_and_rating(5, style3, user)
      
      expect(user.favorite_style).to eq(style3)
    end

  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user)}
    
    it "has method for determining the favorite_brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end
    
    it "without ratings does not have favorite_brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "with one rating, that beer's brewery is favorite" do
      brewery = FactoryGirl.create(:brewery)
      create_beer_with_rating_and_place_to_brewery(10, brewery, user)
      expect(user.favorite_brewery).to eq(brewery)
    end
    
    it "is the one with best average rating" do
      brew1 = FactoryGirl.create(:brewery)
      brew2 = FactoryGirl.create(:brewery)
      brew3 = FactoryGirl.create(:brewery)
      create_beer_with_rating_and_place_to_brewery(1, brew1, user)
      create_beer_with_rating_and_place_to_brewery(1, brew1, user)
      create_beer_with_rating_and_place_to_brewery(1, brew1, user)
      create_beer_with_rating_and_place_to_brewery(10, brew2, user)
      create_beer_with_rating_and_place_to_brewery(1, brew2, user)
      create_beer_with_rating_and_place_to_brewery(1, brew2, user)
      create_beer_with_rating_and_place_to_brewery(5, brew3, user)
      create_beer_with_rating_and_place_to_brewery(5, brew3, user)
      create_beer_with_rating_and_place_to_brewery(5, brew3, user)
      
      expect(user.favorite_brewery).to eq(brew3)
    end

  end

end

def create_beer_with_rating(score, user)
  style = FactoryGirl.create(:style)
  create_beer_with_style_and_rating(score, style, user)
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_style_and_rating(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_place_to_brewery(score, brewery, user)
  beer = create_beer_with_rating(score, user)
  brewery.beers << beer
end
