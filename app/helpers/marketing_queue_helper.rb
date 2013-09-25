module MarketingQueueHelper

	# Figures out which brand should be in the Queue
	def marketing_queue_brands
		@marketing_queue_brands ||= Brand.where(queue: true).order("UPPER(name)")
	end

end
