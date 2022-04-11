# unmodified from hyrax
module Extensions
  module Hyrax
    module CollectionPresenter
      module TotalCounts
        delegate :num_collections, :num_works, to: :solr_document

        def total_items
          num_works + num_collections
        end
    
        def total_viewable_items
          num_works + num_collections
        end
    
        def total_viewable_works
          num_works
        end
    
        def total_viewable_collections
          num_collections
        end
      end
    end
  end
end
