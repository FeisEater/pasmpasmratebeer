class Style < ActiveRecord::Base
  include RatingAverage
  
  has_many :beers
  has_many :ratings, through: :beers
  
  def to_s
    self.name
  end
end
