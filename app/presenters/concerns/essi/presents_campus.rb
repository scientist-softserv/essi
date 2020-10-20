module ESSI
  module PresentsCampus
    def campus
      CampusAttributeRenderer.new(solr_document.campus).render_dl_row
    end
  end
end
