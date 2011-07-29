# encoding: utf-8
require "net/https"
require "uri"

class GoogleReader::Login
	class LoginError < GoogleReaderError; end

	attr_reader :auth, :sid, :lsid

	def initialize(email, password, source=nil, service=nil)
		@email = email
		@password = password
		@service = service || "reader"
		@source  = source  || "application-identifier"
		@auth
		@sid
		@lsid
	end

	def loggedin?
		@auth ? true : false
	end

	def authenticate
		auth_hash = Hash.new

		url = URI.parse("https://www.google.com/accounts/ClientLogin")
		req = Net::HTTP::Post.new(url.request_uri)
		req.set_form_data(
			:accountType => 'GOOGLE',
			:Email       => @email,
			:Passwd      => @password,
			:service     => @service,
			:source      => @source
		)
		Net::HTTP.start(url.host, url.port) do |https|
			https.use_ssl = true
			https.verify_mode = OpenSSL::SSL::VERIFY_PEER
			https.ca_file = "/etc/ssl/certs/ca-certificates.crt"
			https.verify_depth = 5
			res = https.request(req)
			case res
			when Net::HTTPSuccess
				res.body.split("\n").each do |data|
					key,value = data.split("=")
					auth_hash[key.downcase] = value
				end
			end
		end

		@sid  = auth_hash['sid']
		@lsid = auth_hash['lsid']
		@auth = auth_hash['auth']
	rescue e
		false
	end
end

