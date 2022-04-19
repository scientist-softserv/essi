module Extensions
  module Hyrax
    module PresenterFactory
      module SolrRowLimit
        # Modified with increased row limit
        #
        # @return [Array<SolrDocument>] a list of solr documents in no particular order
        def load_docs
          query("{!terms f=id}#{ids.join(',')}", rows: 5000)
            .map { |res| ::SolrDocument.new(res) }
        end
      end
    end
  end
end