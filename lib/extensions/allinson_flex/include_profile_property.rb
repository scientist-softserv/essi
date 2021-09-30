# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module IncludeProfileProperty
      # modified from allinson_flex: added _adminonly variant
      # array of valid values for indexing
      INDEXING = %w[admin_only
                    displayable
                    facetable
                    searchable
                    sortable
                    stored_searchable
                    stored_sortable
                    symbol
                    fulltext_searchable].freeze

      def self.included(base)
        base.class_eval do
          const_set(:INDEXING, INDEXING)

          # modified from allinson_flex: adds error messaging here at parent level
          validates_associated :texts, message: ->(object, data) do
            "for #{object.name} are invalid"
          end
        end
      end
    end
  end
end
