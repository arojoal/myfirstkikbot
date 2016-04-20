module KiK
	# Generic API Client for all Kik API features.
	class Api
		ROOT_URL = 'https://api.kik.com'

		@bot = ""
		@api_key = ""

		# :param bot: Your bot's username
    	# :param api_key: Your bot's API key
		def initialize bot, api_key
			@bot = bot
			@api_key = api_key
		end

		# Sets your bot's configuration
		#
        # * +config+ - A :class:`Configuration<kik.Configuration>` containing your bot's new configuration
        #
		# returns A dict containing the response from the API.
		#        Usage:
        # >>> 
        # >>> kik = KiK::Api.new BOT_USERNAME, BOT_API_KEY
        # >>> config = KiK::Configuration.new 'https://example.com/incoming'
        # >>> kik.set_configuration config
        #
		def set_configuration config
			response = send_post '/v1/config', config
	        puts response.inspect
	        if response.status_code != 200
	            raise KikError(response.text)
	        end
	        return response.json()
	    end

	    protected

	    def send_post method, data
			uri = URI("#{KiK::Api::ROOT_URL}#{method}")
			res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
				req = Net::HTTP::Post.new(uri)
				req.basic_auth @bot, @api_key
				req['Content-Type'] = 'application/json'
				# The body needs to be a JSON string, use whatever you know to parse Hash to JSON
				req.body = data.to_json
				puts req.inspect
				http.request(req)
			end
	    end
	end


    # Model for your bot's configuration.
    # :param webhook: URL the API will send incoming messages to
    # :param features: Feature flags to set
    
	class Configuration
		@webhook = ""
		@features = {"manuallySendReadReceipts" => false,
            "receiveReadReceipts" => false,
            "receiveDeliveryReceipts" => false,
            "receiveIsTyping" => false}

	    def initialize webhook, features=nil
	        @webhook = webhook
	        @features = features unless features.nil?
	    end
	end
end