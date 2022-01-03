# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  class ArchivalMaterialPresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsNumPages
    include ESSI::PresentsOCR
    include ESSI::PresentsPDF
    include ESSI::PresentsRelatedUrl
    include ESSI::PresentsStructure

    delegate :series, :viewing_direction, :viewing_hint,
             to: :solr_document

    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::ArchivalMaterial
    include ESSI::PresentsCampus
    include ESSI::PresentsHoldingLocation
    delegate(*delegated_properties, to: :solr_document)
  end
end
