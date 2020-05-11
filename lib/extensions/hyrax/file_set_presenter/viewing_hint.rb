module Extensions
  module Hyrax
    module FileSetPresenter
      module ViewingHint
        delegate :viewing_hint, :thumbnail_id, to: :solr_document
        #@todo remove after upgrade to Hyrax 3.x
        delegate :original_file_id, to: :solr_document
      end
    end
  end
end  
