require 'httparty'

module WP
  module SaladTwilioApp
    module Helpers
      module ProAPI

        class ProAPI
          include HTTParty
          format :json

          @api_key = ENV['b79d0d684247fa6f95dc00794900ce2c']

          def self.reverse_phone(number)
            uri = 'https://proapi.whitepages.com/2.0/phone.json?phone=4259853735&api_key=b79d0d684247fa6f95dc00794900ce2c'
            get(uri)
          end

        end

        class ProAPIResponse

          def initialize(response)
            @response = response
          end

          attr_reader :response

          def phone
            puts "I am in phone - start"
            return nil if response['results'].length == 0
            phone_id = response['results'][0]
            retrieve_by_id(phone_id)
            puts "I am in phone - end #{phone_id}"
          end

          def entities_from_phone(phone)
            puts "I am in entities_from_phone - start"
            entities = phone['belongs_to']
            puts "I am in entities_from_phone - after belongs_to"
            entities.map do |entity|
              entity = retrieve_by_id(entity['id']['key'])
              # Businesses have name; people have best_name.
              entity['name'] || entity['best_name']
              puts "I am in entities_from_phone - end"
            end.reject(&:empty?)
          end

          def location_from_phone(phone)
            best_location = retrieve_by_id(phone['best_location']['id']['key'])
            best_location['address'] if best_location
            puts "I am in location_from_phone - end"
          end

          def retrieve_by_id(id)
            response['dictionary'][id] if id && response && response['dictionary'][id]
          end

        end

        def reverse_phone(number)
          ProAPI.reverse_phone(number)
        end

        def formatted_result(response)
          response = ProAPIResponse.new(response)
          #puts "I am in formatted_result - after response #{response}"
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
