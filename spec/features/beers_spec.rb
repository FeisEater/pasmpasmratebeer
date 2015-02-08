require 'rails_helper'

describe "Beers page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
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
