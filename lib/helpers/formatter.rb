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

        def format_message(result)
          message = Message.new(result)
          "#{ message.entities } #{ message.location } #{ message.phone_type } #{ message.carrier }"
        end

        def split_message(message)
          messages = message.scan(/.{1,150}/)
          if messages.length > 1
            messages.each_with_index.map{ |m, i| "#{ m } (#{ i + 1 } of #{ messages.length })" }
          else
            [message]
          end
        end

      end
    end
  end
end
