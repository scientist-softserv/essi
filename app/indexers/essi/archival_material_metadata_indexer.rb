module ESSI
  class ArchivalMaterialMetadataIndexer < Hyrax::DeepIndexingService
    self.stored_and_facetable_fields += %i[date_created publication_place]
    self.stored_fields += %i[viewing_direction viewing_hint related_url]
    self.stored_fields.delete :date_created
  end
end
