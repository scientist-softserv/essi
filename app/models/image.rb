# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include ESSI::ImageBehavior
  include ::Hyrax::WorkBehavior
  include StructuralMetadata
  include ExtraLockable
  # include ESSI::NumPagesMetadata
  include ESSI::NumPagesBehavior
  include ESSI::OCRBehavior
  # include ESSI::OCRMetadata
  include IiifPrint.model_configuration(
    pdf_split_child_model: self,
    derivative_service_plugins: [
      IiifPrint::JP2DerivativeService,
      IiifPrint::PDFDerivativeService,
      IiifPrint::TextExtractionDerivativeService,
      IiifPrint::TIFFDerivativeService,
      ESSI::FileSetOCRDerivativesService
    ]
  )

  self.indexer = ImageIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # Include extended metadata common to most Work Types
  # include ESSI::ExtendedMetadata

  # This model includes metadata properties specific to the Image Work Type
  # include ESSI::ImageMetadata

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include AllinsonFlex::DynamicMetadataBehavior
  include ESSI::DynamicMetadataBehavior
  include ::Hyrax::BasicMetadata
end
