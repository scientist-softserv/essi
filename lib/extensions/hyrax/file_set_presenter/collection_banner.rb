module Extensions
  module Hyrax
    module FileSetPresenter
      module CollectionBanner
        def collection
          # return fileset collection if any, else nil
          FileSet.find(id)&.parent&.member_of_collections&.first
        end
      end
    end
  end
end
