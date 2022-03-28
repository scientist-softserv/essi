# unmodified from hyrax
module Extensions
  module Hyrax
    module CollectionPresenter
      module TotalCounts
        delegate :num_collections, :num_works, to: :solr_document

        def tree_collection_ids
          @tree_collection_ids ||= ::Collection.tree_collections_for(id).map(&:id)
        end

        def all_items
          ::ActiveFedora::Base.where(member_of_collection_ids_ssim: tree_collection_ids)
        end

        def total_items
          all_items.count
        end
    
        def total_viewable_items
          all_items.accessible_by(current_ability).count
        end
    
        def total_viewable_works
          all_items.where(generic_type_sim: 'Work').accessible_by(current_ability).count
        end
    
        def total_viewable_collections
          all_items.where(generic_type_sim: 'Collection').accessible_by(current_ability).count
        end
      end
    end
  end
end
