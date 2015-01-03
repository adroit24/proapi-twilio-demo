require 'httparty'

module WP
  module SaladTwilioApp
    module Helpers
      module ProAPI

        class ProAPI
          include HTTParty
          format :json

          @api_key = '660a4c3daff6a8204198bce967ba3b4c' #ENV['API_KEY']''

          def self.reverse_phone(number)
            uri = 'https://proapi.whitepages.com/2.0/phone.json?'
            get(uri, :query => { :phone => number, :api_key => @api_key })
          end

        end

        class ProAPIResponse

          def initialize(response)
            @response = response
            #puts "I am in phone - initialize #{@response}"
          end

          attr_reader :response

          def phone
            puts "I am in phone - start:  #{response['results'].length}"
            return nil if response['results'].length == 0
            phone_id = response['results'][0]
            puts "I am in phone - end: #{phone_id}"
            retrieve_by_id(phone_id)
          end

          def entities_from_phone(phone)
            puts "I am in entities_from_phone - start: #{phone['line_type']}"
            entities = phone['belongs_to']
            puts "I am in entities_from_phone - after belongs_to"
            entities.map do |entity|
              entity = retrieve_by_id(entity['id']['key'])
              # Businesses have name; people have best_name.
              entity['name'] || entity['best_name']
              puts "I am in entities_from_phone - end #{entity['best_name']}"
            end.reject(&:blank?)
          end

          def location_from_phone(phone)
            best_location = retrieve_by_id(phone['best_location']['id']['key'])
            best_location['address'] if best_location
            puts "I am in location_from_phone - end"
          end

          def retrieve_by_id(id)
            puts "Dictionary length #{response['dictionary'].length}"
            response['dictionary'][id] if id && response && response['dictionary'][id]
          end

        end

        def reverse_phone(number)
          ProAPI.reverse_phone(number)
        end

        def formatted_result(response)
          response = ProAPIResponse.new(response)
          puts "I am in formatted_result - after response"
          phone = response.phone
          {

            entities: response.entities_from_phone(phone),
            location: response.location_from_phone(phone),
            type: phone['line_type'],
            carrier: phone['carrier'],
          }
        end

      end
    end
  end
end
