require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

require_relative 'helpers'
 
module WP
  module SaladTwilioApp
    class Application < Sinatra::Base

      helpers Helpers::ProAPI
      helpers Helpers::Formatter

      get '/reverse-phone' do
        number = format_number(params[:From])

        result = result(reverse_phone(number))
        message = format_message(result)

        Twilio::TwiML::Response.new do |r|
          r.Sms message
        end.text
      end

    end
  end
end
