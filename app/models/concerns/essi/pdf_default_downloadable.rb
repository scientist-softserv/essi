module ESSI
  module PDFDefaultDownloadable
    def self.included(base)
      base.class_eval do
        after_initialize do |work|
          work.pdf_state = 'downloadable' if work.pdf_state.blank?
        end
      end
    end
  end
end
