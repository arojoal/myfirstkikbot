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
  	# read list of parkings
  	parkings = ParkingsDonostiService::get_parkings_info
  	parking_names = parkings.keys

  	# check if the received command contents a parking name or not
  	selected_parking = nil
  	message_body = message["body"].downcase
  	parking_names.each do |name|
  		if !name.nil? and message_body.include? name.downcase
	  		selected_parking = name 
	  		break
	  	end
  	end

  	if selected_parking.nil?
  		#send generic message
  		body = "Hola, de qué parking quieres tener información?"
  	else
  		#send parking info
  		body = "El parking de #{selected_parking} tiene en este momento #{parkings[selected_parking][:libres]} plazas libres. Quieres información de algún otro parking?"
  	end
	keyboard_responses = parking_names.map{|name| {"type" => "text", "body" => name}  }

  	responses = []
	message["participants"].each do |participant|
		response = {
            "chatId"=> message["chatId"],
            "type"=> "text",
            "to"=> participant,
            "body"=> body,
            "keyboards"=> [
                {
                    "type"=> "suggested",
                    "responses"=> keyboard_responses
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
