module ESSI
  module RemoteLookupMetadata
    extend ActiveSupport::Concern

    included do
      property :source_metadata_identifier,
               predicate: ::RDF::URI.new("http://library.princeton.edu/terms/metadata_id"),
               multiple: false do |index|
                 index.as :stored_searchable, :symbol
      end
      property :source_metadata,
               predicate: ::RDF::URI.new("http://library.princeton.edu/terms/source_metadata"),
               multiple: false
    end
  end
end
