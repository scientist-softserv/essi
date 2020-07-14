# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  # Generated controller for PagedResource
  class PagedResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include ESSI::WorksControllerBehavior
    include ESSI::PagedResourcesControllerBehavior
    include ESSI::RemoteMetadataLookupBehavior
    include Hyrax::BreadcrumbsForWorks
    include ESSI::BreadcrumbsForWorks
    include ESSI::OCRSearch
    include ESSI::StructureBehavior
    self.curation_concern_type = ::PagedResource

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::PagedResourcePresenter

    def pdf
      resource = PagedResource.find(params[:id]) if params[:id]

      if (resource && resource.allow_pdf_download == "true") || (resource && current_ability.current_user.admin?)
        pdf = ESSI::GeneratePdfService.new(resource).generate

        send_file pdf[:file_path],
          filename: pdf[:file_name],
          type: 'application/pdf',
          disposition: 'inline'
      else
        redirect_to "/concern/paged_resources/#{resource.id}?locale=en",
          alert: 'You do not have access to download this PDF.'
      end
    end
  end
end
