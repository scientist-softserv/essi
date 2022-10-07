# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  class PagedResourcePresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsDelegatedAttributes
    include ESSI::PresentsOCR
    include ESSI::PresentsPDF
    include ESSI::PresentsStructure

    delegate :series, :viewing_direction, :viewing_hint,
             to: :solr_document

    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::PagedResource
    include ESSI::PresentsCustomRenderedAttributes
    delegate(*delegated_properties, to: :solr_document)
  end
end
