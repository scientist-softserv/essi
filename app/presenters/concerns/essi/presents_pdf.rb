module ESSI
  module PresentsPDF
    delegate :allow_pdf_download, to: :solr_document
  end
end
