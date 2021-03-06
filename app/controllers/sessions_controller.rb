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
  
  def create_oauth
    user = User.find_by username: env["omniauth.auth"].info.nickname
    user = User.create(username: env["omniauth.auth"].info.nickname, password: "EnMäJaksanuK00data", password_confirmation: "EnMäJaksanuK00data", banned: false) if user.nil?
    if user.banned
      redirect_to :back, notice:'your account is banned, please contact admin'
    else
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end
  
end
