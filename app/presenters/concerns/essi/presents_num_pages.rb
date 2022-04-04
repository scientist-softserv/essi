module ESSI
  module PresentsNumPages
    delegate :num_pages, :number_of_pages, to: :solr_document
  end
end
