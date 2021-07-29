# Makes extracted text check available in file details.
module Extensions
  module Hyrax
    module FileSetPresenter
      module ExtractedText
        delegate :extracted_text, to: :solr_document
        
        def extracted_text?
          extracted_text.present?
        end
      
        def extracted_text_link
          "/downloads/#{id}?file=extracted_text"
        end
      end
    end
  end 
end
