module ESSI
  module PresentsRelatedUrl
    delegate :catalog_url, :related_url, to: :solr_document
  end
end
