# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  class ScientificPresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Scientific
    include ESSI::PresentsCampus
    include ESSI::PresentsHoldingLocation
    delegate(*delegated_properties, to: :solr_document)
  end
end
