module ESSI
  class FileSetOCRDerivativesService < Hyrax::FileSetDerivativesService

    # We have to do this if we never call super on other methods. See create_derivatives notes below with FIXME
    def initialize(file_set)
      @file_set = file_set
    end

    def create_derivatives(filename)
      return if ESSI.config.dig(:essi, :skip_derivatives)

      # FIXME: Fix MiniMagick problems so we can still call super here to create thumbnails?
      # When we call create_derivatives upstream via super, we initiate thumbnail creation via MiniMagick.
      # This is randomly failing, which causes OCR jobs to get missed on affected FileSets.
      # We don't really need thumbnails as we derive them from the IIIF server, but what are the impacts?
      # See https://github.com/IU-Libraries-Joint-Development/essi/issues/118
      #
      # super
      create_ocr_derivatives(filename)
    end

    private

      def supported_mime_types
        file_set.class.image_mime_types
      end

      def create_ocr_derivatives(filename)
        return unless ESSI.config.dig(:essi, :create_ocr_files)
        
        OCRRunner.create(filename,
                         { source: :original_file,
                           outputs: [{ label: "#{file_set.id}-alto.xml",
                                       mime_type: 'text/html; charset=utf-8',
                                       format: 'xml',
                                       container: 'extracted_text',
                                       language: file_set.ocr_language,
                                       url: uri }]})
      end
  end
end
