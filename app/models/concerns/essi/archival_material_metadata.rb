module ESSI
  module ArchivalMaterialMetadata
    extend ActiveSupport::Concern

    included do
      # Add properties that would only be appropriate for use in objects of the Archival Material Work Type
      property :viewing_hint, predicate: ::RDF::Vocab::IIIF.viewingHint, multiple: false
      property :viewing_direction, predicate: ::RDF::Vocab::IIIF.viewingDirection, multiple: false
    end
  end
end
