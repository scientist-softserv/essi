# Generated via
#  `rails generate hyrax:work BibRecord`
class BibRecordIndexer < Hyrax::WorkIndexer
  include ESSI::IndexesBibRecordMetadata # Replaces IndexesBasicMetadata
  include ESSI::BibRecordIndexerBehavior
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
  self.model_class = ::BibRecord

end
