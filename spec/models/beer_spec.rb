require 'rails_helper'

RSpec.describe Beer, :type => :model do
  it "is created with a name and style" do
    beer = Beer.create name:"name", style:"style"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  
  it "is not created with empty name" do
    beer = Beer.create name:"", style:"style"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)  
  end

  it "is not created with empty style" do
    beer = Beer.create name:"name", style:""
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)  
  end
end
