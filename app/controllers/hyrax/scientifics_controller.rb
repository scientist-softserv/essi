# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  # Generated controller for Scientific
  class ScientificsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include ESSI::WorksControllerBehavior
    include ESSI::ScientificsControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include ESSI::BreadcrumbsForWorks
    include ESSI::OCRSearch
    include ESSI::StructureBehavior
    include AllinsonFlex::DynamicControllerBehavior
    self.curation_concern_type = ::Scientific

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ScientificPresenter
  end
end
