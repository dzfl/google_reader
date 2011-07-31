# encoding: utf-8

class GoogleReader::Feed
	attr_reader :feedurl
	def initialize(hash, api)
		@id           = hash["id"]
		@title        = hash["title"]
		@sortid       = hash["sortid"]
		@firstitemsec = hash["firstitemsec"]
		@feedurl      = hash["id"][5..-1]
		@htmlurl      = hash["htmlurl"]

		@api = api
	end

	def unread_items(count = 20)
		a = @api.get("/reader/atom/feed/#{feedurl}", {:n => count,:xt => 'user/-/state/com.google/read'})
		@api.parse_xml(a)
	end


end

