module Extensions
  module Hyrax
    module Forms
      module CollectionForm
        module FileSetBackedBranding
          def banner_info
            @banner_info ||= begin
              # Find Banner filename
              banner_info = ::CollectionBrandingInfo.where(collection_id: id).where(role: "banner")
              banner_file = ::File.split(banner_info.first.local_path).last unless banner_info.empty?
              file_location = banner_info.first.local_path unless banner_info.empty?
              relative_path = "/" + banner_info.first.local_path.split("/")[-4..-1].join("/") unless banner_info.empty?
              { file: banner_file, full_path: file_location, relative_path: relative_path }
            end
          end
    
          def logo_info
            @logo_info ||= begin
              # Find Logo filename, alttext, linktext
              logos_info = ::CollectionBrandingInfo.where(collection_id: id).where(role: "logo")
              logos_info.map do |logo_info|
                logo_file = ::File.split(logo_info.local_path).last
                relative_path = "/" + logo_info.local_path.split("/")[-4..-1].join("/")
                alttext = logo_info.alt_text
                linkurl = logo_info.target_url
                { file: logo_file, full_path: logo_info.local_path, relative_path: relative_path, alttext: alttext, linkurl: linkurl }
              end
            end
          end
        end
      end
    end
  end
end
