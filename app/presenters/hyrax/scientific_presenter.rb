# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  class ScientificPresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsHoldingLocation
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Scientific
    delegate(*delegated_properties, to: :solr_document)
    include ESSI::PresentsCampus
  end
end
