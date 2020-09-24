module ESSI
  module CampusMetadata
    extend ActiveSupport::Concern

    included do
      property :university_place,
               predicate: ::RDF::Vocab::MARCRelators.uvp,
               multiple: false do |index|
                 index.as :stored_searchable, :facetable
               end
    end
  end
end
