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
        puts "I am in proapi_result_message"
        number = format_number(params[:From])
        puts "I am in proapi_result_message - after number format #{number}"
        result = formatted_result(reverse_phone('4259853735))
        puts "I am in proapi_result_message - after result format #{result}"
        format_message(result)
        puts "I am in proapi_result_message - after format_message"
      end

    end
  end
end
