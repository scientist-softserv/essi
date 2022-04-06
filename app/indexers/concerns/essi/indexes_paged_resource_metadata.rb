module ESSI
  module IndexesPagedResourceMetadata
    # We're overriding a method from IndexBasicMetadata
    def rdf_service
      ESSI::PagedResourceMetadataIndexer
    end
  end
end
