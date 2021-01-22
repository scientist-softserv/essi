module ESSI
  class ScientificMetadataIndexer < Hyrax::DeepIndexingService
    self.stored_and_facetable_fields += %i[date_created]
    self.stored_fields += %i[related_url]
    self.stored_fields.delete :date_created
  end
end
