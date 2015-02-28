class RatingsController < ApplicationController
  #optimoinnissa ei käytetty monisäikeisyyttä
  def index
    @ratings = Rails.cache.fetch('recent ratings', expires_in: 10.minutes) do
      Rating.recent
    end
    @most_active_users = Rails.cache.fetch('most active users', expires_in: 10.minutes) do
      User.most_active
    end
    @top_breweries = Rails.cache.fetch('top breweries', expires_in: 10.minutes) do
      RatingAverage.top Brewery, 3
    end
    @top_beers = Rails.cache.fetch('top beers', expires_in: 10.minutes) do
      RatingAverage.top Beer, 3
    end
    @top_styles = Rails.cache.fetch('top styles', expires_in: 10.minutes) do
      RatingAverage.top Style, 3
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to @rating.beer
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end

