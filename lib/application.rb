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
          r.Sms proapi_result_message
        end.text
      end

      get '/call' do
        Twilio::TwiML::Response.new do |r|
          r.Say proapi_result_message
        end.text
      end

      def proapi_result_message
        
        puts params[:Body]
        phone_re = /^[0-9]{10}$/

        is_match = phone_re.match(params[:Body])
 
        puts "is_match result #{is_match}"

        number = format_number(params[:From])

        result = formatted_result(reverse_phone(number))
        format_message(result)
      end

    end
  end
end
