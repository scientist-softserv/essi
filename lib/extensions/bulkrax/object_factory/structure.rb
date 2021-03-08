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
            # Override - add admin_set_id, structure to accepted fields
            super + %i[admin_set_id structure]
          end

      end
    end
  end
end
