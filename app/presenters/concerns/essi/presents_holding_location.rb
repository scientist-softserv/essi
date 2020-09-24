module ESSI
  module PresentsHoldingLocation
    def holding_location
      HoldingLocationAttributeRenderer.new(solr_document.holding_location).render_dl_row
    end
  end
end
