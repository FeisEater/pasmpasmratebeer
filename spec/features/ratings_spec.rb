require 'rails_helper'

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Maija", password:"Maija2", password_confirmation:"Maija2" }

  before :each do
    sign_in(username:"Pekka1", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  #it "shows 0 when no ratings" do
  #  visit ratings_path
  #  expect(page).to have_content 'Number of ratings: 0'
  #end
  
  #it "shows amount of ratings" do
  #  make_rating beer1, '10'
  #  make_rating beer2, '15'
  #  make_rating beer1, '20'
  #  visit ratings_path
  #  expect(page).to have_content 'Number of ratings: 3'
  #  expect(page).to have_content 'iso 3 10 Pekka1'
  #  expect(page).to have_content 'Karhu 15 Pekka1'
  #  expect(page).to have_content 'iso 3 20 Pekka1'
  #end
  
  it "on user page, shows only user's ratings" do
    make_rating beer1, '10'
    make_rating beer2, '15'
    make_rating beer1, '20'
    sign_in(username:"Maija", password:"Maija2")
    make_rating beer2, '5'
    sign_in(username:"Pekka1", password:"Foobar1")
    visit user_path(user)
    expect(page).to have_content 'iso 3 10'
    expect(page).to have_content 'Karhu 15'
    expect(page).to have_content 'iso 3 20'
  end
  
  it "can delete own ratings" do
    make_rating beer1, '10'
    make_rating beer2, '15'
    make_rating beer1, '20'
    visit user_path(user)
    expect{
      page.find('li', :text => 'Karhu').click_on('delete')
    }.to change{Rating.count}.from(3).to(2)
  end
  
  it "shows favorite beer style and brewery" do
    make_rating beer1, '10'
    visit user_path(user)
    expect(page).to have_content 'Lager is his favorite style'
    expect(page).to have_content 'Koff is his favorite brewery'
  end
end

def make_rating(beer, score)
  visit new_rating_path
  select(beer.name, from:'rating[beer_id]')
  fill_in('rating[score]', with:score)
  click_button "Create Rating"
end
