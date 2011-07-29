module GoogleReader

	class Login
		require 'net/https'
		require 'uri'
		
		LoginError = Class.new Exception

		attr_reader :auth, :sid, :lsid

		def initialize(email, password, source=nil, service=nil)
			@email = email
			@password = password
			@service = service || "service-identifier"
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
			https = Net::HTTP.new(url.host, url.port)
			https.use_ssl = true
			https.verify_mode = OpenSSL::SSL::VERIFY_PEER
			https.ca_file = "/etc/ssl/certs/ca-certificates.crt"
			https.verify_depth = 5
			req = Net::HTTP::Post.new(url.path)
			req.set_form_data({
				:accountType => 'GOOGLE',
				:Email       => @email,
				:Passwd      => @password,
				:service     => @service,
				:source      => @source
			})
			res = ""
			https.start do
				res = https.request(req)
				if res.code == "200"
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

end

