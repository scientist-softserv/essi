module ESSI
  class BibRecordMetadataIndexer < Hyrax::DeepIndexingService
    self.stored_and_facetable_fields += %i[date_created]
    self.stored_fields += %i[viewing_direction related_url]
    self.stored_fields.delete :date_created
  end
end
