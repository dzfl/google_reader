
module GoogleReader

	class Api
		attr_reader :auth, :token
		def initialize(source, service)
			@source  = source  || "application-identifier"
			@service = service || "service-identifier"
			@auth
			@token
		end

		def login(email, password)
			login = Login.new(email, password, @source, @service)
			login.authenticate
			@auth = login.auth
			@token = get_token
		end

		def get_token
			resbody = get("/reader/api/0/token")
			resbody.sub(/\/\//, "")
		end

		#private
		def get(path)
			req = Net::HTTP::Get.new(path)
			req.add_field "Authorization", "GoogleLogin auth=#{@auth}"
			Net::HTTP.new('www.google.com', 80).start do |http|
				res = http.request(req)
				res.body
			end
		end

	end

end

