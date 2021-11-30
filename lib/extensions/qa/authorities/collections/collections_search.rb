module Extensions
  module Qa
    module Authorities
      module Collections
        module CollectionsSearch
          # unmodified from hyrax
          def search(_q, controller)
            # The Hyrax::CollectionSearchBuilder expects a current_user
            return [] unless controller.current_user
            repo = ::CatalogController.new.repository
            builder = search_builder(controller)
            response = repo.search(builder)
            docs = response.documents
            docs.map do |doc|
              id = doc.id
              title = doc.title
              { id: id, label: title, value: id }
            end
          end
        end
      end
    end
  end
end
