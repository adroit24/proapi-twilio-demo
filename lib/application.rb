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
        number = format_number(params[:From])
        result = formatted_result(reverse_phone('4259853735'))
        format_message(result)
      end

    end
  end
end
