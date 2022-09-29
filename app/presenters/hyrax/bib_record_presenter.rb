# Generated via
#  `rails generate hyrax:work BibRecord`
module Hyrax
  class BibRecordPresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsDelegatedAttributes
    include ESSI::PresentsOCR
    include ESSI::PresentsStructure
    delegate :series, to: :solr_document
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::BibRecord
    include ESSI::PresentsCampus
    include ESSI::PresentsHoldingLocation
    delegate(*delegated_properties, to: :solr_document)
  end
end
