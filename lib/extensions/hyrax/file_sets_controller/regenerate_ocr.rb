module Extensions
  module Hyrax
    module FileSetsController
      module RegenerateOCR
      
        def regenerate_ocr
          file_set = FileSet.find(presenter.id)
          file_id = file_set&.original_file&.id
          if file_set.present? && file_id.present?
            CreateOCRJob.perform_later(file_set, file_id)
            redirect_to [main_app, presenter], notice: 'Regenerating OCR'
          else
            redirect_to [main_app, presenter], alert: 'Unable to regenrate OCR due to misssing original file'
          end
        end
      end
    end
  end
end
