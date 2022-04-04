# a work type applying this module must have its own indexer to avoid
# impacting Hyrax::BasicMetadataIndexer and impacting other classes
module ESSI
  module IndexesNumPages
    extend ActiveSupport::Concern

    included do
      self.new(nil).rdf_service.class_eval do
        self.stored_and_facetable_fields += %i[num_pages]
      end
    end

    # added to properly drop "m" from number_of_pages indexing
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc[Solrizer.solr_name('number_of_pages',
                                    :stored_sortable,
                                    type: :integer)] = object.send(:pages)
      end
    end
  end
end
