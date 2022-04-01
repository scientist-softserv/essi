module ESSI
  module IndexesCollectionDescendants
    extend ActiveSupport::Concern

    def rdf_service
      ESSI::CollectionMetadataIndexer
    end

    included do
      self.new(nil).rdf_service.class_eval do
        self.stored_fields += %i[num_collections num_works]
      end
    end
  end
end
