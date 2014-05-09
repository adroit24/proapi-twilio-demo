module WP
  module SaladTwilioApp
    module Helpers
      module Formatter

        def format_number(input)
          input[2, 10] if input
        end

        def format_message(result)
          message = ResultString.new(result)
          "#{ message.entities } #{ message.location } #{ message.phone_type } #{ message.carrier }"
        end

        class ResultString

          def initialize(result)
            @result = result
          end

          def entities
            "#{ @result[:entities].length } associated people and businesses found#{ entity_names }."
          end

          def location
            location = @result[:location].strip if @result[:location]
            location ? "Best location is #{ location }." : "No location found."
          end

          def phone_type
            type = @result[:type] || 'unknown'
            "Phone type is #{ type.downcase }."
          end

          def carrier
            carrier = @result[:carrier] || 'unknown'
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
