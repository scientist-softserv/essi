module ESSI
  module PDFDownload
    def self.included(base)
      base.class_eval do
        skip_load_and_authorize_resource only: :pdf
      end
    end
  
    def pdf
      if presenter.allow_pdf_download?
        pdf = ESSI::GeneratePdfService.new(presenter.solr_document).generate

        send_file pdf[:file_path],
                  filename: pdf[:file_name],
                  type: 'application/pdf',
                  disposition: 'inline'
      else
        redirect_to [main_app, curation_concern],
                    alert: 'You do not have access to download this PDF.'
      end
    end
  end
end
