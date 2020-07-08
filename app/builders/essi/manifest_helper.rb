module ESSI
  class ManifestHelper < Hyrax::ManifestHelper
    include Rails.application.routes.url_helpers
    include ActionDispatch::Routing::PolymorphicRoutes

    # File is copied over from Hyrax for overriding methods

    # Build a rendering hash for pdf
    #
    # @return [Hash] rendering
    def build_pdf_rendering(file_set_id)
      file_set_document = query_for_rendering(file_set_id)
      paged_resource_id = file_set_document.dig(:is_page_of_ssi)

      {
        "@id"=> pdf_hyrax_paged_resource_path(paged_resource_id),
        "label"=> "Download as PDF",
        "format"=> "application/pdf"
      }
    end
  end
end
