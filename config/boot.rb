ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# lines to force rails to listen on any IP of the virtual machine. see http://stackoverflow.com/questions/28668436/how-to-change-the-default-binding-ip-of-rails-4-2-development-server

require 'rails/commands/server'
module Rails
  class Server
    def default_options
      super.merge(Host: '0.0.0.0', Port: 3000)
    end
  end
end
