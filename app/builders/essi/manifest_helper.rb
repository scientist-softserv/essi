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
      pdf_path = file_set_document.to_h.with_indifferent_access.dig(:parent_path_tesi).to_s + '/pdf'

      {
        "@id"=> pdf_path,
        "label"=> "Download as PDF",
        "format"=> "application/pdf"
      }
    end
  end
end
