module ESSI
  module IndexesArchivalMaterialMetadata

    # We're overriding a method from IndexBasicMetadata
    def rdf_service
      ESSI::ArchivalMaterialMetadataIndexer
    end

  end
end
