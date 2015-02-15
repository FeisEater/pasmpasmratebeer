require 'rails_helper'

describe "Beers page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }
  let!(:style) { FactoryGirl.create :style }
  
  before :each do
    sign_in(username:"Pekka1", password:"Foobar1")
  end

  it "creates beer if valid name" do
    visit beers_path
    click_link "New Beer"
    fill_in('beer[name]', with:'pivo')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
  
  it "doesn't create beer, shows error message if invalid name" do
    visit beers_path
    click_link "New Beer"
    fill_in('beer[name]', with:'')
    click_button "Create Beer"
    expect(page).to have_content 'New Beer'
    expect(page).to have_content "Name can't be blank"
  end
end
