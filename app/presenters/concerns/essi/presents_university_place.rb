module ESSI
  module PresentsUniversityPlace
    def university_place
      UniversityPlaceAttributeRenderer.new(solr_document.university_place).render_dl_row
    end
  end
end
