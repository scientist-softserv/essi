module ESSI
  module PDFTerms
    extend ActiveSupport::Concern
    included do
      self.terms += [:allow_pdf_download]
    end
  end
end
