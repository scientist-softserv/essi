AllinsonFlex.setup do |config|
  config.m3_schema_version_tag = '856237c2c6c64385619a643c88138fc5a776f7a8'

end
Hyrax::CurationConcern.actor_factory.insert_before Hyrax::Actors::ModelActor, AllinsonFlex::DynamicSchemaActor
