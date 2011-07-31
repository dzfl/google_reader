# encoding: utf-8

class GoogleReader::Subscription
	def initialize(api)
		@api  = api
		update
	end

	def update
		@subscriptions = @api.get_json("/reader/api/0/subscription/list")["subscriptions"]
	end

	##
	# subscription list
	def list
		@subscriptions
	end
end






