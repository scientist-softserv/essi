module ESSI
  module CampusMetadata
    extend ActiveSupport::Concern

    included do
      property :university_place, predicate: ::RDF::Vocab::MARCRelators.uvp
    end
  end
end
