# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  # Generated form for PagedResource
  class PagedResourceForm < Hyrax::Forms::WorkForm
    self.model_class = ::PagedResource
    self.terms += [:resource_type, :series]
    self.required_fields -= [:title, :creator, :keyword]
    self.primary_fields = [:title, :creator, :rights_statement]
    include ESSI::PagedResourceFormBehavior
    include ESSI::OCRTerms
    include ESSI::PurlTerms
    include ESSI::RemoteMetadataFormElements
  end
end
