class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy, :join, :quit]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :admin_logged_in, only: [:destroy]

  # GET /beer_clubs
  # GET /beer_clubs.json
  def index
    @beer_clubs = BeerClub.all
  end

  # GET /beer_clubs/1
  # GET /beer_clubs/1.json
  def show
  end

  # GET /beer_clubs/new
  def new
    @beer_club = BeerClub.new
  end

  def join
    if not @beer_club.members.include? current_user
      join_club_with_current_user false
      redirect_to @beer_club, notice: "#{current_user.username}, welcome to the club!"
    else
      redirect_to beer_clubs_path, notice: "Already in the club"
    end
  end
  
  def confirm
    @beer_club = BeerClub.find params[:club_id]
    if @beer_club.confirmed_members.include? current_user
      member = User.find params[:user_id]
      membership = member.memberships.select{|m| m.beer_club == @beer_club}
      if membership.empty?
        return redirect_to :back, notice: "Something went wrong"
      end
      membership.first.confirmed = true
      membership.first.save
      redirect_to @beer_club, notice: "Confirmed #{current_user.username}'s membership!"
    else
      redirect_to :back, notice: "Can't confirm membership if not confirmed member"
    end
  end
  
  def quit
    if @beer_club.members.include? current_user
      @beer_club.members.destroy current_user
      redirect_to current_user
    else
      redirect_to beer_clubs_path, notice: "Can't quit club if wasn't in it"
    end
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs
  # POST /beer_clubs.json
  def create
    @beer_club = BeerClub.new(beer_club_params)
    join_club_with_current_user true
    
    respond_to do |format|
      if @beer_club.save
        format.html { redirect_to @beer_club, notice: 'Beer club was successfully created.' }
        format.json { render :show, status: :created, location: @beer_club }
      else
        format.html { render :new }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1
  # PATCH/PUT /beer_clubs/1.json
  def update
    respond_to do |format|
      if @beer_club.update(beer_club_params)
        format.html { redirect_to @beer_club, notice: 'Beer club was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer_club }
      else
        format.html { render :edit }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_clubs/1
  # DELETE /beer_clubs/1.json
  def destroy
    @beer_club.destroy
    respond_to do |format|
      format.html { redirect_to beer_clubs_url, notice: 'Beer club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer_club
      @beer_club = BeerClub.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_club_params
      params.require(:beer_club).permit(:name, :founded, :city)
    end
    
    def join_club_with_current_user(confirmed)
      membership = Membership.new
      membership.user = current_user
      membership.beer_club = @beer_club
      membership.confirmed = confirmed
      membership.save
    end
end
