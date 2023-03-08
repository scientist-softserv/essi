module ESSI
  module Actors
    class PerformLaterActor < Hyrax::Actors::AbstractActor
      def create(env)
        # Short circuit to next actor if we are running from a job.
        if env.attributes.delete 'in_perform_later_actor_job'
          super
        else
          env.attributes['in_perform_later_actor_job'] = true
          PerformLaterActorJob.perform_later('create', env.curation_concern.class.to_s, env.current_ability.current_user, env.attributes)
        end
      end

      def update(env)
        # Short circuit to next actor if we are running from a job.
        if env.attributes.delete 'in_perform_later_actor_job'
          env.curation_concern.class.new # force-load newest profile
          env.curation_concern.update_dynamic_schema
          super
        # Adding a conditional when coming from IIIF Print
        # @see https://github.com/scientist-softserv/iiif_print/blob/d14246664048c708071c7ff4de2e9a34aa703465/lib/iiif_print/jobs/create_relationships_job.rb#L70
        elsif env.attributes.keys.include?('work_members_attributes')
          super
        else
          env.attributes['in_perform_later_actor_job'] = true
          PerformLaterActorJob.perform_later('update', env.curation_concern, env.current_ability.current_user, env.attributes)
        end
      end

      def destroy(env)
        # Short circuit to next actor if we are running from a job.
        if env.attributes.delete 'in_perform_later_actor_job'
          super
        else
          env.attributes['in_perform_later_actor_job'] = true
          PerformLaterActorJob.perform_later('destroy', env.curation_concern, env.current_ability.current_user, env.attributes)
        end
      end
    end
  end
end
