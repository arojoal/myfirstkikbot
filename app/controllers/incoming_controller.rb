class IncomingController < ApplicationController
  protect_from_forgery except: [:receive_messages]

  def receive_messages
  	messages = params["messages"]
	process_received_messages messages
  end

  protected

  def process_received_messages messages
  	responses = []
  	messages.each do |message|
  		responses += process_message(message)
  	end
	kik = KiK::Api.new ENV['RAILS_KIK_BOT_USERNAME'],ENV['RAILS_KIK_BOT_API_KEY']
  	kik.send_messages responses
  end

  def process_message message
  	responses = []
	message["participants"].each do |participant|
		response = {
            "chatId"=> message["chatId"],
            "type"=> "text",
            "to"=> participant,
            "body"=> "Hello #{participant}, how are you?",
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
        responses << response
	end
	responses
  end

  def get_command_from_body body
  end

end
