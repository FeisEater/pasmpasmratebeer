class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.banned
        redirect_to :back, notice:'your account is banned, please contact admin'
      else
        # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
        session[:user_id] = user.id
        # uudelleen ohjataan käyttäjä omalle sivulleen
        redirect_to user, notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "User #{params[:username]} does not exist! Dummy!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
  
end
