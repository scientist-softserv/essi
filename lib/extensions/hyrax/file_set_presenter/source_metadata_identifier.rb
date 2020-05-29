module Extensions
  module Hyrax
    module FileSetPresenter
      module SourceMetadataIdentifier
        delegate :source_metadata_identifier, to: :solr_document
      end
    end
  end
end  
