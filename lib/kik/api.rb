module KiK
	# Generic API Client for all Kik API features.
	class Api
		ROOT_URL = 'https://api.kik.com'
		#ROOT_URL = 'http://192.168.33.17:4000'

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
	    end


        # Sends a batch of messages.
        # :param messages: List of :class:`Message <kik.messages.Message>` to be sent.
        # :type messages: list[kik.messages.Message]
        # :returns: A dict containing the response from the API
        # :rtype: dict
        # .. note:: Subject to limits on the number of messages sent, documented at
        #     `<https://dev.kik.com/#/docs/messaging#sending-messages>`_.
        # Usage:
        # >>> from kik import KikApi
        # >>> from kik.messages import TextMessage
        # >>> kik = KikApi(BOT_USERNAME, BOT_API_KEY)
        # >>> kik.send_messages([
        # >>>     TextMessage(
        # >>>         to='ausername',
        # >>>         chat_id='2e566cf66b07d9622053b2f0e44dd14926d89a6d61adf496844781876d62cca6',
        # >>>         body='Some Text'
        # >>>     )
        # >>> ])
        #
		def send_messages messages
			response = send_post '/v1/message', {"messages" => messages }
	    end

	    def send_message
	    	response = send_post '/v1/message', \
	    	{"messages" => [
		        {
		            #{}"chatId"=> "b3be3bc15dbe59931666c06290abd944aaa769bb2ecaaf859bfb65678880afab",
		            "type"=> "text",
		            "to"=> "arojoal",
		            "body"=> "How are you?",
		            "keyboards"=> [
		                {
		                    "type"=> "suggested",
		                    "responses"=> [
		                        {
		                            "type"=> "text",
		                            "body"=> "Good :)"
		                        },
		                        {
		                            "type"=> "text",
		                            "body"=> "Not so good :("
		                        }
		                    ]
		                }
		            ]
		        }
		    ]}
		end

		def create_code data
	    	response = send_post '/v1/code', {"data" => data}
	    	return response
		end

		# see color_codes at https://dev.kik.com/#/docs/messaging#kik-codes-api
		def get_code_url code_id, color_code
			"https://api.kik.com/v1/code/#{code_id}?c=#{color_code}"
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
	        #puts res.inspect
	        puts res.code
	        puts res.body
	        if res.code != "200"
	            raise KikError(res.body)
	        end
	        return JSON.parse(res.body)
	    end
	end


    # Model for your bot's configuration.
    # :param webhook: URL the API will send incoming messages to
    # :param features: Feature flags to set
    
	class Configuration
		@webhook = ""
		@features = {}

	    def initialize webhook, features=nil
	        @webhook = webhook
			@features = {"manuallySendReadReceipts" => false,
	            "receiveReadReceipts" => false,
	            "receiveDeliveryReceipts" => false,
	            "receiveIsTyping" => false} if features.nil?
	        @features = features unless features.nil?
	    end
	end
end