module ESSI
  module PDFBehavior
    def pdf
      resource = self.class.curation_concern_type.find(params[:id]) if params[:id]

      if (resource && resource.allow_pdf_download == "true") || (resource && current_ability.current_user.admin?)
        pdf = ESSI::GeneratePdfService.new(resource).generate

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
