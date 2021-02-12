module ESSI
  class ImageMetadataIndexer < Hyrax::DeepIndexingService
    self.stored_and_facetable_fields += %i[date_created publication_place]
    self.stored_fields += %i[related_url]
    self.stored_fields.delete :date_created
  end
end
