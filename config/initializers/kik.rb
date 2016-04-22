require "kik/api"

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
end

