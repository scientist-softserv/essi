module ESSI
  module PDFMetadata
    extend ActiveSupport::Concern
    included do
      property :allow_pdf_download, predicate: ::RDF::Vocab::DCAT.accessURL, multiple: false, boolean: true do |index|
        index.as :stored_searchable
      end
    end
  end
end
