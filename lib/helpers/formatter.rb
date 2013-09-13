module WP
  module SaladTwilioApp
    module Helpers
      module Formatter

        def format_number(input)
          input[2, 10] if input
        end

        class Message

          def initialize(result)
            @result = result
          end

          def entities
            "#{ @result[:entities].length } associated people/businesses #{ entity_names } found."
          end

          def location
            location = @result[:location].strip
            location ? "Best location is #{ location }." : "No location found."
          end

          def phone_type
            type = @result[:type].downcase || 'unknown'
            "Phone type is #{ type }."
          end

          def carrier
            carrier = @result[:carrier] || 'unknown'
            "Phone carrier is #{ carrier }."
          end

          private

          def entity_names
            entities = @result['entities']
            entities.join(' ') if entities
          end

        end

        def format_message(result)
          puts result
          message = Message.new(result)
          "#{ message.entities } #{ message.location } #{ message.phone_type } #{ message.carrier }"
        end

      end
    end
  end
end
