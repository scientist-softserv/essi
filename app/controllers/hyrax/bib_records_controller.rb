# Generated via
#  `rails generate hyrax:work BibRecord`
module Hyrax
  # Generated controller for BibRecord
  class BibRecordsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include ESSI::WorksControllerBehavior
    include ESSI::BibRecordsControllerBehavior
    include ESSI::RemoteMetadataLookupBehavior
    include Hyrax::BreadcrumbsForWorks
    include ESSI::BreadcrumbsForWorks
    include ESSI::OCRSearch
    include ESSI::StructureBehavior
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::BibRecord

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::BibRecordPresenter
  end
end
