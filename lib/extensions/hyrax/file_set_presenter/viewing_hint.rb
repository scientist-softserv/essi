module Extensions
  module Hyrax
    module FileSetPresenter
      module ViewingHint
        delegate :viewing_hint, :thumbnail_id, to: :solr_document
      end
    end
  end
end  
