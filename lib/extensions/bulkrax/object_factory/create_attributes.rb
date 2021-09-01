module Extensions
  module Bulkrax
    module ObjectFactory
      module CreateAttributes
        # modified from bulkrax
        def create_attributes
          fix_membership(super)
        end

        def attribute_update
          fix_membership(super)
        end

        # fixes bulkrax 0.1.0/1.0.x differences in collection attribute
        def fix_membership(attributes)
          attributes['member_of_collections_attributes']&.each do |k,v|
            if v['id'].is_a?(Hash)
              attributes['member_of_collections_attributes'][k] = v['id']
            end
          end
          attributes
        end
      end
    end
  end
end
