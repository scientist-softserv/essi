# Generated via
#  `rails generate hyrax:work PagedResource`
class PagedResourceIndexer < Hyrax::WorkIndexer
  include ESSI::IndexesPagedResourceMetadata # Replaces IndexesBasicMetadata
  include ESSI::PagedResourceIndexerBehavior
  include ESSI::IIIFThumbnailBehavior
  include ESSI::IndexesNumPages

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
  include AllinsonFlex::DynamicIndexerBehavior
  self.model_class = ::PagedResource

end
