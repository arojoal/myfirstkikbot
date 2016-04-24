require "kik/api"
require "open-uri"

Rails.logger.info "Initializing KiK Bot Environment...."

unless ENV['RAILS_KIK_BOT_USERNAME'].present? and ENV['RAILS_KIK_BOT_API_KEY'].present? and ENV['RAILS_KIK_WEBHOOK'].present?
	puts "!!!!!!YOU MUST SET THE FOLLOGIN ENV VARIABLES BEFORE STARTING RAILS SERVER!!!!:"
	puts
	puts "RAILS_KIK_BOT_USERNAME"
	puts "RAILS_KIK_BOT_API_KEY"
	puts "RAILS_KIK_WEBHOOK"
	puts

	exit
else
	kik = KiK::Api.new ENV['RAILS_KIK_BOT_USERNAME'],ENV['RAILS_KIK_BOT_API_KEY']
	config = KiK::Configuration.new ENV['RAILS_KIK_WEBHOOK']
	kik.set_configuration config

	#check if we have downloaded KIK CODE IMAGE for welcome webpage, if not, generate code and download to local file
	image_path = Rails.root.join(Rails.application.config.welcome_page_kik_code_image_path)
	unless File.file?(image_path)
		code_info = kik.create_code "welcome"
		Rails.logger.debug "KikCode Image info: #{code_info}"
		unless code_info.nil? or code_info["id"].nil?

			url = kik.get_code_url code_info["id"],0

			Rails.logger.debug "Downloading welcome kik code image from #{url} into #{image_path}"
			File.open(image_path, 'wb') do |fo|
			  fo.write open(url).read 
			end
		end
	end

end

