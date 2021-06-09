module AllinsonFlex
  class DynamicSchemaActor < Hyrax::Actors::AbstractActor
    # modified from allinson_flex to not force update
    def create(env)
      add_dynamic_schema(env, update: false)
      next_actor.create(env)
    end

    # modified from allinson_flex with explicit update argument
    def update(env)
      add_dynamic_schema(env, update: true)
      next_actor.update(env)
    end

    # @param [Hyrax::Actors::Environment] env
    # modified from allinson_flex with explicit update argument
    def add_dynamic_schema(env, update: true)
      schema = env.curation_concern.dynamic_schema_service(as_id: env.attributes[:admin_set_id], update: update ).dynamic_schema
      env.curation_concern.dynamic_schema = schema
      env.attributes[:dynamic_schema_id] = schema.id
      env.attributes[:profile_version] = schema.profile_version.to_f
    end
  end
end
