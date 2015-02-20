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
    ratings.order(score: :desc).limit(1).first.beer
  end
  
  def favorite_style
    return nil if ratings.empty?
    styles = ratings.group_by {|r| r.beer.style}
    styles = styles.map{|k,v| [k, average(v)]}
    styles.sort_by {|k,v| v}.last[0]    #0 index gets the key, ie. style name
  end
  
  def favorite_brewery
    return nil if ratings.empty?
    breweries = ratings.group_by {|r| r.beer.brewery}
    breweries = breweries.map{|k,v| [k, average(v)]}
    breweries.sort_by {|k,v| v}.last[0]    #0 index gets the key, ie. style name
  end
  
  def self.most_active
    sorted_by_amount_of_ratings = User.all.sort_by{ |u| u.ratings.count }
    sorted_by_amount_of_ratings.take 3
  end
  
  private
  
  def average(a)
    a = a.map{|r| r.score}
    a.inject{ |sum, n| sum + n} / a.count
  end
end
