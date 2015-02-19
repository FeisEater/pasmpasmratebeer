module RatingAverage
	extend ActiveSupport::Concern
	
	def average_rating
		#a = ratings.map{ |r| r.score }
		#a.inject{ |sum, n| sum + n} / a.count
		ratings.average(:score)
	end
	
	def self.top(clazz, n)
	  sorted_by_rating_in_desc_order = clazz.all.sort_by{ |b| -(b.average_rating||0) }
	  sorted_by_rating_in_desc_order.take n
	end
end
