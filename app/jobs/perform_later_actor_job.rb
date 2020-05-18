class PerformLaterActorJob < ActiveJob::Base
  def perform(action, curation_concern, ability_user, attributes_for_actor)
    # create action needs a new object, update/destroy should pass in the existing object.
    curation_concern = curation_concern.constantize.new if curation_concern.is_a? String

    # Rebuild the actor environment and send it down the actor stack.
    env = Hyrax::Actors::Environment.new(curation_concern, ::Ability.new(ability_user), attributes_for_actor)
    Hyrax::CurationConcern.actor.send(action, env)
  end
end
