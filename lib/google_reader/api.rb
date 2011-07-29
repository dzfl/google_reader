# encoding: utf-8

require "json"
require "net/https"
require "uri"

class GoogleReader::API
	def initialize(source, service)
		@source  = source  || "application-identifier"
		@service = service || "reader"
		@end_point = URI("http://www.google.com")
	end

	def login(email, password)
		url = URI.parse("https://www.google.com/accounts/ClientLogin")
		req = Net::HTTP::Post.new(url.request_uri)
		req.set_form_data(
			:accountType => 'GOOGLE',
			:Email       => email,
			:Passwd      => password,
			:service     => @service,
			:source      => @source
		)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		http.ca_file = "/etc/ssl/certs/ca-certificates.crt"
		http.verify_depth = 5
		http.start do |http|
			res = http.request(req)
			case res
			when Net::HTTPSuccess
				res.body.split("\n").each do |data|
					k, v = *data.split('=')
					case k.downcase
					when 'sid'
						@sid = v
					when 'lsid'
						@lsid = v
					when 'auth'
						@auth = v
					end
				end
			end
		end
	#rescue => e
	#	false
	#ensure
	#	true
	end

	def logged_in?
		!!@auth
	end

	def token
		@token ||= get("/reader/api/0/token").sub(/\/\//, "")
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

	def get_json(path, params={})
		res = get(path, params.merge(:output => 'json'))
		JSON.parse(res)
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

