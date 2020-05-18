module Extensions
  module Hyrax
    module Dashboard
      module CollectionsController
        module FileSetBackedBranding
          def show
            if @collection.collection_type.brandable?
              @banner_file = @collection.banner_branding.first&.file_set_image_path
            end
    
            presenter
            query_collection_members
          end

          private
    
            def update_existing_banner
              banner_info = @collection.banner_branding.first
              banner_info.save
            end
    
            def add_new_banner(uploaded_file_ids)
              f = uploaded_files(uploaded_file_ids).first
              banner_info = ::CollectionBrandingInfo.new(
                collection_id: @collection.id,
                filename: ::File.split(f.file_url).last,
                role: "banner",
                alt_txt: "",
                target_url: ""
              )
              banner_info.save(uploaded_file_id: uploaded_file_ids.first,
                               user_key: @current_user.user_key)
            end
    
            def remove_banner
              @collection.banner_branding&.delete_all
            end
    
            def update_logo_info(uploaded_file_id, alttext, linkurl)
              logo_info = ::CollectionBrandingInfo.where(collection_id: @collection.id.to_s).where(role: "logo").where(local_path: uploaded_file_id.to_s)
              logo_info.first.alt_text = alttext
              logo_info.first.target_url = linkurl
              logo_info.first.local_path = uploaded_file_id
              logo_info.first.save
            end
    
            def create_logo_info(uploaded_file_id, alttext, linkurl)
              file = uploaded_files(uploaded_file_id)
              logo_info = ::CollectionBrandingInfo.new(
                collection_id: @collection.id,
                filename: ::File.split(file.file_url).last,
                role: "logo",
                alt_txt: alttext,
                target_url: linkurl
              )
              logo_info.save(uploaded_file_id: uploaded_file_id,
                             user_key: @current_user.user_key)
              logo_info
            end
    
            def remove_redundant_files(public_files)
              # remove any public ones that were not included in the selection.
              @collection.logo_branding.each do |logo_info|
                logo_info.destroy unless public_files.include? logo_info.local_path
              end
            end
        end
      end
    end
  end
end
