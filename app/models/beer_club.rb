class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  
  def confirmed_members
    mems = memberships.select{ |m| m.confirmed }
    mems = mems.map{ |m| m.user }
    mems.reject{ |m| m.nil? }
  end
  def unconfirmed_members
    mems = memberships.reject{ |m| m.confirmed }
    mems = mems.map{ |m| m.user }
    mems.reject{ |m| m.nil? }
  end

end
