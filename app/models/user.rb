class User < ActiveRecord::Base
  include RatingAverage
  
  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 },
                       format: { with: /.*[A-Z].*/},
                       format: { with: /.*[0-9].*/}

  has_many :ratings   # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships
  
  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end
  
  def favorite_style
    favorite :style
  end
  
  def favorite_brewery
    favorite :brewery
  end
  
  def self.most_active
    sorted_by_amount_of_ratings = User.all.sort_by{ |u| u.ratings.count }.reverse
    sorted_by_amount_of_ratings.take 3
  end
  
  def confirmed_memberships
    mems = memberships.select{ |m| m.confirmed }
    mems = mems.map{ |m| m.beer_club }
    mems.reject{ |m| m.nil? }
  end
  def unconfirmed_memberships
    mems = memberships.reject{ |m| m.confirmed }
    mems = mems.map{ |m| m.beer_club }
    mems.reject{ |m| m.nil? }
  end
  
  def confirmed_member_of(club)
    confirmed_memberships.include? club
  end
  
  private
  
  def favorite(category)
    return nil if ratings.empty?
    items = ratings.group_by {|r| r.beer.send(category)}
    items = items.map{|k,v| [k, average(v)]}
    items.sort_by {|k,v| v}.last[0]    #0 index gets the key, ie. style name
  end
  
  def average(a)
    a = a.map{|r| r.score}
    a.inject{ |sum, n| sum + n} / a.count
  end
end
