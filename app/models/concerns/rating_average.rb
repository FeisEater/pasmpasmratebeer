module RatingAverage
	extend ActiveSupport::Concern
	
	def average_rating
		#a = ratings.map{ |r| r.score }
		#a.inject{ |sum, n| sum + n} / a.count
		ratings.average(:score)
	end
end
