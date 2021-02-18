# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  class PagedResourcePresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsHoldingLocation
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsPDF
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure
    include ESSI::PresentsCampus

    delegate :series, :viewing_direction, :viewing_hint,
             to: :solr_document

    # Overrides hyrax
    # IIIF rendering linking property for inclusion in the manifest
    #  Called by the `iiif_manifest` gem to add a 'rendering' (eg. a link a download for the resource)
    #
    # @return [Array] array of rendering hashes
    def sequence_rendering
      rendering_ids = solr_document[:file_set_ids_ssim]

      renderings = []
      if rendering_ids.present?
        # We only want a single PDF link rendering for the work as a whole
        # Use build_pdf_rendering to build the rendering block but don't iterate over all rendering_ids
        if solr_document[:allow_pdf_download_tesim] == ["true"] || current_ability.current_user.admin?
          renderings << manifest_helper.build_pdf_rendering(rendering_ids&.first)
        end
      end
      renderings.flatten.uniq
    end

    def manifest_helper
      @manifest_helper ||= ESSI::ManifestHelper.new(request.base_url)
    end
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::PagedResource
    delegate(*delegated_properties, to: :solr_document)
  end
end
