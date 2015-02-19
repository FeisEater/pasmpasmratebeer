class RatingsController < ApplicationController
  def index
    @ratings = Rating.recent
    @most_active_users = User.most_active
    @top_breweries = RatingAverage.top Brewery, 3
    @top_beers = RatingAverage.top Beer, 3
    @top_styles = RatingAverage.top Style, 3
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

