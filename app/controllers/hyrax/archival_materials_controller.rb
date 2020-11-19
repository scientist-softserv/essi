# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  # Generated controller for ArchivalMaterial
  class ArchivalMaterialsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include ESSI::WorksControllerBehavior
    include ESSI::PagedResourcesControllerBehavior
    include ESSI::RemoteMetadataLookupBehavior
    include Hyrax::BreadcrumbsForWorks
    include ESSI::BreadcrumbsForWorks
    include ESSI::OCRSearch
    include ESSI::PDFBehavior
    include ESSI::StructureBehavior
    self.curation_concern_type = ::ArchivalMaterial
    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ArchivalMaterialPresenter
  end
end
