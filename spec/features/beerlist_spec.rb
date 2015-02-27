require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
    visit beerlist_path
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js: true do
    expect(page).to have_content "Nikolai"
  end
  
  it "sorts by beer name by default", js:true do
    three_items_in_following_order "Fastenbier", "Lechte Weisse", "Nikolai"
  end
  
  it "on click sorts by style", js:true do
    click_link "Style"
    three_items_in_following_order "Lager", "Rauchbier", "Weizen"
  end

  it "on click sorts by brewery", js:true do
    click_link "Brewery"
    three_items_in_following_order "Ayinger", "Koff", "Schlenkerla"
  end
  
  def three_items_in_following_order(item1, item2, item3)
    expect(find('table').find('tr:nth-child(2)')).to have_content item1
    expect(find('table').find('tr:nth-child(3)')).to have_content item2
    expect(find('table').find('tr:nth-child(4)')).to have_content item3
  end
end
