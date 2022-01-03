module ESSI
  module PDFBehavior
    extend ActiveSupport::Concern

    def pdf_downloadable?
      return true if self.pdf_state == 'downloadable'
      return false
    end

    def to_solr(solr_doc = {})
      super.tap do |doc|
        doc[Solrizer.solr_name('pdf_downloadable',
                               Solrizer::Descriptor.new(:boolean, :stored, :indexed))] = self.pdf_downloadable?
      end
    end
  end
end
