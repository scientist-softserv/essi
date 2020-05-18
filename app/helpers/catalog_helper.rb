# frozen_string_literal: true
module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  ##
  # Get the URL to a document's thumbnail image
  # Overrides Blacklight behaviour
  #
  # @param [SolrDocument, Presenter] document
  # @return [String]
  def thumbnail_url document
    return document.thumbnail_path if document.try(:thumbnail_path).present?
    if document.id == document.thumbnail_id
      representative_document = document
    else
      representative_document = ::SolrDocument.find(document.thumbnail_id)
    end

    thumbnail_file_id = representative_document.original_file_id
    if thumbnail_file_id
      Hyrax.config.iiif_image_url_builder.call(thumbnail_file_id, nil, '250,')
    else
      raise 'thumbnail_file_id is nil'
    end

  rescue
    image_path 'default.png'
  end
end
