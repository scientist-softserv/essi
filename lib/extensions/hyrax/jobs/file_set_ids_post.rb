module Extensions
  module Hyrax
    module Jobs
      module FileSetIdsPost
        # POST to avoid URI Too Long error from solr, and raise row limit
        def file_set_ids(work)
          ::FileSet.search_with_conditions({id: work.member_ids},
                                           {method: :post, rows: 10000}).map(&:id)
        end
      end
    end
  end
end