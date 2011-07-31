# encoding: utf-8

describe GoogleReader do
	before :all do
		@pit = Pit.get( "google.com", :require => {
			"email" => "your email in google",
			"password" => "your password in google"
		})
	end

	describe GoogleReader::API do
		before :all do
			@api = GoogleReader::API.new( "rspec", "reader" )
			@api.login(@pit["email"], @pit["password"])
		end
		context "ログインして" do
			context "成功した時" do
				it "#logged_in? #=> true" do
					@api.logged_in?.should == true
				end
				it "AuthIDが取得できる" do
					@api.auth.should_not == nil
				end
				it "Tokenが取得できる" do
					@api.token.should_not == nil
				end
			end
		end

		it "Feedが取得できる" do
			@api.fetch_raw_feed("http://d.hatena.ne.jp/aereal/rss").class.should == RSS::Atom::Feed
		end

		it "購読リストを取得できる" do
			@api.subscription.list.class.should == Array
		end

	end

end


