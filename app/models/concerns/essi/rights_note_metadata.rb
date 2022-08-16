module ESSI
  module RightsNoteMetadata
    extend ActiveSupport::Concern

    included do
      property :rights_note, predicate: 'http://purl.org/dc/elements/1.1/rights',
      multiple: false do |index|
        index.as :stored_searchable
      end
    end
  end
end
