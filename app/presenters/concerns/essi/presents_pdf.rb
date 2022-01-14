module ESSI
  module PresentsPDF
    delegate :pdf_downloadable, to: :solr_document

    def allow_pdf_download?
      pdf_downloadable || current_ability.current_user.admin?
    end

    # Overrides hyrax
    def manifest_helper
      @manifest_helper ||= ESSI::ManifestHelper.new(request.base_url)
    end

    # Overrides hyrax
    # IIIF rendering linking property for inclusion in the manifest
    #  Called by the `iiif_manifest` gem to add a 'rendering' (eg. a link a download for the resource)
    #
    # @return [Array] array of rendering hashes
    def sequence_rendering
      rendering_ids = solr_document[:file_set_ids_ssim]

      renderings = []
      if rendering_ids.present? && allow_pdf_download?
        # We only want a single PDF link rendering for the work as a whole
        # Use build_pdf_rendering to build the rendering block but don't iterate over all rendering_ids
        renderings << manifest_helper.build_pdf_rendering(rendering_ids&.first)
      end
      renderings.flatten.uniq
    end

  end
end
