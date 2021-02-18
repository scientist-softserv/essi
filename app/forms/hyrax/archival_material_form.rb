# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
module Hyrax
  # Generated form for ArchivalMaterial
  class ArchivalMaterialForm < Hyrax::Forms::WorkForm
    self.model_class = ::ArchivalMaterial

    self.terms += [:resource_type, :series]
    self.required_fields -= [:title, :creator, :keyword]
    self.primary_fields = [:profile_version, :title, :creator, :rights_statement]
    include ESSI::ArchivalMaterialFormBehavior
    include ESSI::HoldingLocationTerms
    include ESSI::OCRTerms
    include ESSI::PDFTerms
    include ESSI::RemoteMetadataFormElements
    include AllinsonFlex::DynamicFormBehavior
    include ESSI::CampusTerms

    def work_requires_files?
      false
    end
  end
end
