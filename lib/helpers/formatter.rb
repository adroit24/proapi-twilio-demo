require 'wolfram-alpha'

module WP
  module SaladTwilioApp
    module Helpers
      module Formatter

        def format_number(input)
          input[2, 10] if input
        end

        def format_message(result)
          message = ResultString.new(result)
         # puts "I am in format_message"
          "#{ message.entities } \n #{ message.location } \n #{ message.phone_type } \n #{ message.carrier } "
        end

        class ResultString

          def initialize(result)
            @result = result
          end

          def entities
          #  puts "#{ @result[:entities].length } associated people and businesses found#{ entity_names }."
            "#{ @result[:entities].length } associated people and businesses found#{ entity_names }."
          end

          def location
            location = @result[:location].strip if @result[:location]

            #wolfarm-alpha data pull

            options = { "format" => "plaintext" } # see the reference appendix in the documentation.[1]
            client = WolframAlpha::Client.new "K7V79W-EA8G6KTX7W", options

            clientQueryText = "Population of " + location

            wa_response = client.query clientQueryText

            input = wa_response["Input"] # Get the input interpretation pod.
            result = wa_response.find { |pod| pod.title == "Result" } # Get the result pod.  

            population = result.subpods[0].plaintext

            location ? "Best location is #{ location }. Population here is #{ population}" : "No location found."
          end

          def phone_type
            type = @result[:type] || 'unknown'
          #  puts "Phone type is #{ type.downcase }."
            "Phone type is #{ type.downcase }."
          end

          def carrier
            carrier = @result[:carrier] || 'unknown'
          #  puts "Phone carrier is #{ carrier }."
            "Phone carrier is #{ carrier }."
          end

          private

          def entity_names
            entities = @result[:entities]
            ": #{ entities.join(', ') }" if entities && entities.length > 0
          end

        end

      end
    end
  end
end
