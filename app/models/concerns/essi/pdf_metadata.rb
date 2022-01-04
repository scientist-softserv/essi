module ESSI
  module PDFMetadata
    extend ActiveSupport::Concern
    included do
      property :pdf_state, predicate: ::RDF::URI.new('http://dlib.indiana.edu/vocabulary/PDFState'), multiple: false do |index|
        index.as :stored_searchable
      end
    end
  end
end
