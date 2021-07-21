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
        (defined?(super) ? super : [] ) - [:campus]
      end

      def custom_rendered_properties
        (defined?(super) ? super : [] ) + [:campus]
      end
    end

    def campus(options: {})
      CampusAttributeRenderer.new(solr_document.campus, options).render_dl_row
    end
  end
end
