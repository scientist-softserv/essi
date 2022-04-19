module Extensions
  module Hyrax
    module Jobs
      module FileSetIdsPost
        # POST to avoid URI Too Long error from solr, and raise row limit
        # Uses solr terms query parser to support large (> 1024) amounts of member_ids
        def file_set_ids(work)
          ::FileSet.search_with_conditions(::ActiveFedora::SolrQueryBuilder.construct_query_for_ids(work.member_ids),
                                           {method: :post, rows: 10_000}).map(&:id)
        end
      end
    end
  end
end