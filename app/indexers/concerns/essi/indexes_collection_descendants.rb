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

    # added to properly drop "m" from indexing
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc[Solrizer.solr_name('num_works',
                                    :stored_sortable,
                                    type: :integer)] = object.try(:num_works).to_i
        solr_doc[Solrizer.solr_name('num_collections',
                                    :stored_sortable,
                                    type: :integer)] = object.try(:num_collections).to_i
      end
    end
  end
end
