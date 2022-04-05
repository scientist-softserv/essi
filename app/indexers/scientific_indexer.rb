# Generated via
#  `rails generate hyrax:work Scientific`
class ScientificIndexer < Hyrax::WorkIndexer
  include ESSI::IndexesScientificMetadata # Replaces IndexesBasicMetadata
  include ESSI::ScientificIndexerBehavior
  include ESSI::IIIFThumbnailBehavior
  include ESSI::IndexesFilesets
  include ESSI::IndexesNumPages
  include ESSI::IndexesSortableMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
  include AllinsonFlex::DynamicIndexerBehavior
  include ESSI::DynamicIndexerBehavior
  self.model_class = ::Scientific

end
