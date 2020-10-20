# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  # Generated form for Image
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:resource_type]
    self.required_fields -= [:keyword]
    self.primary_fields = [:title, :creator, :rights_statement]
    include ESSI::ImageFormBehavior
    include ESSI::HoldingLocationTerms
    include ESSI::OCRTerms
    include ESSI::PurlTerms
    include ESSI::CampusTerms
  end
end
