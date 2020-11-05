module ESSI
  module PDFBehavior
    def pdf
      if presenter.allow_pdf_download == "true" || current_ability.current_user.admin?
        pdf = ESSI::GeneratePdfService.new(presenter.solr_document).generate

        send_file pdf[:file_path],
                  filename: pdf[:file_name],
                  type: 'application/pdf',
                  disposition: 'inline'
      else
        redirect_to "/concern/#{resource.class.to_s.underscore.pluralize}/#{resource.id}?locale=en",
          alert: 'You do not have access to download this PDF.'
      end
    end
  end
end
