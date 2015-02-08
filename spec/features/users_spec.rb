require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka1", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka1'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka1", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'User Pekka1 does not exist! Dummy!'
    end

  end
  
  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end
