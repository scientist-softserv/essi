# Generated via
#  `rails generate hyrax:work ArchivalMaterial`
class ArchivalMaterialIndexer < Hyrax::WorkIndexer
  include ESSI::IndexesArchivalMaterialMetadata # Replaces IndexesBasicMetadata
  include ESSI::ArchivalMaterialIndexerBehavior
  include ESSI::IIIFThumbnailBehavior
  include ESSI::IndexesNumPages

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
  include AllinsonFlex::DynamicIndexerBehavior
  self.model_class = ::ArchivalMaterial

end
