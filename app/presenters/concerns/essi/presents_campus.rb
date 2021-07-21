module ESSI
  module PresentsCampus
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      # override allinson_flex delegation
      def delegated_properties
        super - [:campus]
      end
    end

    def campus
      CampusAttributeRenderer.new(solr_document.campus).render_dl_row
    end
  end
end
