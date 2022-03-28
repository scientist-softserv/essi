module Extensions
  module Hyrax
    module Dashboard
      module CollectionsController
        module ParamsForQuery
          private

          # You can override this method if you need to provide additional inputs to the search
          # builder. For example:
          #   search_field: 'all_fields'
          # @return <Hash> the inputs required for the collection member query service
          def params_for_query
            params.merge(search_field: 'all_fields', q: params[:cq])
          end
        end
      end
    end
  end
end
