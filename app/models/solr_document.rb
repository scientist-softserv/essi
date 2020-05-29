# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  attribute :num_pages, Solr::String, solr_name('num_pages')
  attribute :holding_location, Solr::String, solr_name('holding_location')
  attribute :viewing_hint, Solr::String, solr_name('viewing_hint')
  attribute :viewing_direction, Solr::String, solr_name('viewing_direction')
  attribute :ocr_searchable, Solr::String, solr_name('ocr_searchable', Solrizer::Descriptor.new(:boolean, :stored, :indexed))
  # @todo remove after upgrade to Hyrax 3.x
  attribute :original_file_id, Solr::String, "original_file_id_ssi"

  def series
    self[Solrizer.solr_name('series')]
  end
  
  def source_metadata_identifier
    self[Solrizer.solr_name('source_metadata_identifier')]&.first
  end
end
