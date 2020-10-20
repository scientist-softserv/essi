module Extensions
  module Bulkrax
    module ObjectFactory
      module Structure

          def work_actor
            # Override to force skipping duplicate perform later
            actor = super
            while(actor.class == ESSI::Actors::PerformLaterActor) do
              actor = actor.next_actor
            end
            actor
          end

          # Regardless of what the Parser gives us, these are the properties we are prepared to accept.
          def permitted_attributes
            # Override - add structure to accepted fields
            super
            klass.properties.keys.map(&:to_sym) + %i[structure]
          end

      end
    end
  end
end
