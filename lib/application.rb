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
        phone_re = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/

        is_match = phone_re.match(params[:Body])
 
        puts is_match

        number = format_number(params[:From])

        result = formatted_result(reverse_phone(number))
        format_message(result)
      end

    end
  end
end
