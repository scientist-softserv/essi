module Extensions
  module Hyrax
    module CollectionPresenter
      module FileSetBackedBranding
        def banner_file
          # Find Banner filename
          ci = ::CollectionBrandingInfo.where(collection_id: id, role: "banner")
          "/" + ci[0].local_path.split("/")[-4..-1].join("/") unless ci.empty?
        end
    
        def logo_record
          logo_info = []
          # Find Logo filename, alttext, linktext
          cis = ::CollectionBrandingInfo.where(collection_id: id, role: "logo")
          return if cis.empty?
          cis.each do |coll_info|
            logo_file = ::File.split(coll_info.local_path).last
            file_location = "/" + coll_info.local_path.split("/")[-4..-1].join("/") unless logo_file.empty?
            alttext = coll_info.alt_text
            linkurl = coll_info.target_url
            logo_info << { file: logo_file, file_location: file_location, alttext: alttext, linkurl: linkurl }
          end
          logo_info
        end
      end
    end
  end
end
