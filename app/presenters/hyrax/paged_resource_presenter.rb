# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  class PagedResourcePresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsOCR
    include ESSI::PresentsStructure
    delegate :series, :viewing_direction, :viewing_hint, :allow_pdf_download,
             to: :solr_document

    def holding_location
      HoldingLocationAttributeRenderer.new(solr_document.holding_location).render_dl_row
    end

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
  end
end
