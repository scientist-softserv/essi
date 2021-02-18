# Generated via
#  `rails generate hyrax:work BibRecord`
module Hyrax
  # Generated form for BibRecord
  class BibRecordForm < Hyrax::Forms::WorkForm
    self.model_class = ::BibRecord
    self.terms += [:resource_type, :series]
    self.required_fields -= [:title, :creator, :keyword]
    self.primary_fields = [:profile_version, :title, :creator, :rights_statement]
    include ESSI::BibRecordFormBehavior
    include ESSI::HoldingLocationTerms
    include ESSI::OCRTerms
    include ESSI::RemoteMetadataFormElements
    include AllinsonFlex::DynamicFormBehavior
    include ESSI::CampusTerms
  end
end
