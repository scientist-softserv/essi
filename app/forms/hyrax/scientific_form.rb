# Generated via
#  `rails generate hyrax:work Scientific`
module Hyrax
  # Generated form for Scientific
  class ScientificForm < Hyrax::Forms::WorkForm
    self.model_class = ::Scientific
    self.terms += [:resource_type]
    self.required_fields -= [:keyword]
    self.primary_fields = [:profile_version, :title, :creator, :rights_statement]
    include ESSI::ScientificFormBehavior
    include ESSI::HoldingLocationTerms
    include ESSI::OCRTerms
    include AllinsonFlex::DynamicFormBehavior
    include ESSI::CampusTerms
  end
end
