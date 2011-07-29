# encoding: utf-8

class GoogleReader::API
	def initialize(source, service)
		@source  = source  || "application-identifier"
		@service = service || "reader"
		@end_point = URI("http://www.google.com/reader")
	end

	def login(email, password)
		login = Login.new(email, password, @source, @service)
		login.authenticate
		@auth = login.auth
		@token = get_token
	end

	def get_token
		resbody = get("/api/0/token")
		resbody.sub(/\/\//, "")
	end

	def authorization_headers
		{"Authorization" => "GoogleLogin auth=#{@auth}"}
	end

	#private
	def get(path, params={})
		uri = @end_point + path
		uri.query = URI.encode_www_form(params)
		req = Net::HTTP::Get.new(uri.request_uri, authorization_headers)
		Net::HTTP.start(uri.host, uri.port) do |http|
			res = http.request(req)
			res.body
		end
	end

	def post(path, params={})
		uri = @end_point + path
		data = URI.encode_www_form(params)
		req = Net::HTTP::Post.new(uri.request_uri, authorization_headers)
		Net::HTTP.start("www.google.com", 80) do |http|
			res = http.request(req, data)
			res.body
		end
	end
end

