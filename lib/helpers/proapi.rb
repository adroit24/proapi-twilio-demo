require 'httparty'

module WP
  module SaladTwilioApp
    module Helpers
      module ProAPI

        class ProAPI
          include HTTParty
          format :json

          @api_key = '85a866b1826f6f5bb54e00e15b003fbd'

          def self.reverse_phone(number)
            uri = 'https://proapi.whitepages.com/2.0/phone.json?'
            get(uri, :query => { :phone => number, :api_key => @api_key })
          end

        end
        
        def reverse_phone(number)
          puts "response: #{ProAPI.reverse_phone(number)}"
          ProAPI.reverse_phone(number)
        end

        def phone(response)
          return nil if response['results'].length == 0
          phone_id = response['results'][0]
          retrieve_by_id(phone_id, response)
        end

        def entities_from_phone(phone, response)
          entities = phone['belongs_to']
          entities.map{ |entity| retrieve_by_id(entity['id'], response)['name'] }
        end

        def location_from_phone(phone, response)
          best_location = retrieve_by_id(phone['best_location']['id'], response)
          best_location['address']
        end
        
        def result(response)
          phone = phone(response)
          {
            entities: entities_from_phone(phone, response),
            location: location_from_phone(phone, response),
            type: phone['line_type'],
            carrier: phone['carrier'],
          }
        end

        def retrieve_by_id(id, response)
          puts "ID: #{id}"
          response['dictionary'][id] if id && response
        end

      end
    end
  end
end
