# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  class ArchivalMaterialPresenter < Hyrax::WorkShowPresenter
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
        rendering_ids.each do |file_set_id|
          if solr_document[:allow_pdf_download_tesim] == ["true"] || current_ability.current_user.admin?
            renderings << manifest_helper.build_pdf_rendering(file_set_id)
          end
        end
      end
      renderings.flatten.uniq
    end

    def manifest_helper
      @manifest_helper ||= ESSI::ManifestHelper.new(request.base_url)
    end
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::ArchivalMaterial
    delegate(*delegated_properties, to: :solr_document)
  end
end
