module Extensions
  module Hyrax
    module CollectionPresenter
      module FileSetBackedBranding
        def banner_file
          # Find Banner filename
          ::CollectionBrandingInfo.where(collection_id: id, role: "banner").map(&:relative_path).first
        end
    
        def logo_record
          # Find Logo filename, alttext, linktext
          ::CollectionBrandingInfo.where(collection_id: id, role: "logo").map(&:display_hash)
        end
      end
    end
  end
end
