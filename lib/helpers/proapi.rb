require 'httparty'

module WP
  module SaladTwilioApp
    module Helpers
      module ProAPI

        class ProAPI
          include HTTParty
          format :json

          @api_key = ENV['API_KEY']

          def self.reverse_phone(number)
            uri = 'https://proapi.whitepages.com/2.0/phone.json?'
            get(uri, :query => { :phone => number, :api_key => @api_key })
          end

        end

        class ProAPIResponse

          def initialize(response)
            @response = response
          end

          def phone
            return nil if @response['results'].length == 0
            phone_id = @response['results'][0]
            retrieve_by_id(phone_id)
          end

          def entities_from_phone(phone)
            entities = phone['belongs_to']
            entities.map do |entity| 
              entity = retrieve_by_id(entity['id']['key'])
              # Businesses have name; people have best_name.
              entity['name'] || entity['best_name']
            end.reject(&:empty?)
          end

          def location_from_phone(phone)
            best_location = retrieve_by_id(phone['best_location']['id']['key'])
            best_location['address'] if best_location
          end

          def retrieve_by_id(id)
            @response['dictionary'][id] if id && @response && @response['dictionary'][id]
          end

        end
        
        def reverse_phone(number)
          ProAPI.reverse_phone(number)
        end

        def result(response)
          response = ProAPIResponse.new(response)
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
