class PlacesController < ApplicationController
  def index
  end
  
  def show
    places = BeermappingApi.places_in(session[:places_city])
    @place = places.select {|p| p.id == params[:id]}[0]
  end

  def search
    session[:places_city] = params[:city]
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

end
