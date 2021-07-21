module ESSI
  module PresentsHoldingLocation
    def self.included(base) 
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      # override allinson_flex delegation
      def delegated_properties
        super - [:holding_location]
      end

      def custom_rendered_properties
        (defined?(super) ? super : [] ) + [:holding_location]
      end
    end

    def holding_location(options: {})
      HoldingLocationAttributeRenderer.new(solr_document.holding_location, options).render_dl_row
    end
  end
end
