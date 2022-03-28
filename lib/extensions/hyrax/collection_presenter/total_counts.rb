# unmodified from hyrax
module Extensions
  module Hyrax
    module CollectionPresenter
      module TotalCounts
        def total_items
          ::ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id}").count
        end
    
        def total_viewable_items
          ::ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id}").accessible_by(current_ability).count
        end
    
        def total_viewable_works
          ::ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id} AND generic_type_sim:Work").accessible_by(current_ability).count
        end
    
        def total_viewable_collections
          ::ActiveFedora::Base.where("member_of_collection_ids_ssim:#{id} AND generic_type_sim:Collection").accessible_by(current_ability).count
        end
      end
    end
  end
end
