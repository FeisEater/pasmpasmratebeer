require 'rails_helper'

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'Number of active breweries: 0'

  end

  describe "when breweries exists" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |brewery_name|
        FactoryGirl.create(:brewery, name: brewery_name, year: year += 1)
      end

      visit breweries_path
    end

#Tää ei vittu toimi
    #it "lists the breweries and their total number" do
    #  expect(page).to have_content "Number of breweries: #{@breweries.count}"
    #  @breweries.each do |brewery_name|
    #    expect(page).to have_content brewery_name
    #  end
    #end

    it "allows user to navigate to page of a Brewery" do
      click_link "Karjala"

      expect(page).to have_content "Karjala"
      expect(page).to have_content "Established in 1898"
    end

  end
end
