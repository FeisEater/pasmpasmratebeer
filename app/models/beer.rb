class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating
		x = 0
		ratings.each do |r|
			x += r.score
		end
		x /= ratings.count
		x
	end
end
