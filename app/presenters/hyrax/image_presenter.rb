# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    include ESSI::PresentsDelegatedAttributes
    include ESSI::PresentsOCR
    include ESSI::PresentsStructure
    include AllinsonFlex::DynamicPresenterBehavior
    self.model_class = ::Image
    include ESSI::PresentsCustomRenderedAttributes
    delegate(*delegated_properties, to: :solr_document)
  end
end
