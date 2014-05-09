require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

require_relative 'helpers'
 
module WP
  module SaladTwilioApp
    class Application < Sinatra::Base

      helpers Helpers::ProAPI
      helpers Helpers::Formatter

      get '/sms' do
        Twilio::TwiML::Response.new do |r|
          r.Sms message
        end.text
      end

      get '/call' do
        Twilio::TwiML::Response.new do |r|
          r.Say message
        end.text
      end

      def message
        number = format_number(params[:From])
        result = result(reverse_phone(number))
        format_message(result)
      end

    end
  end
end
