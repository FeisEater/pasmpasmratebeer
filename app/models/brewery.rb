class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   only_integer: true }
  validate :not_from_future

  def not_from_future
    if year > Time.now.year
      errors[:year] << "Morty! They found me! I don't know how but they found me!"
    end
  end

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil, false] }
  
end
