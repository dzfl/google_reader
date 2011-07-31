# encoding: utf-8

class GoogleReader::Feed
	attr_reader :feedurl
	def initialize(feedurl, api)
		@id = "feed/#{feedurl}"
		@api = api
	end

	def unread_items(count = 20)
	end

	def details
		@api.get_json("/reader/api/0/stream/details", {:s => id })
	end


end

