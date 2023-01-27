# unmodified from Bulkrax::FileFactory
module Extensions
  module Bulkrax
    module ObjectFactory
      module FileFactoryMetadata
        def file_attributes(update_files = false)
          @update_files = update_files
          hash = {}
          return hash if klass == Collection
          hash[:uploaded_files] = upload_ids if attributes[:file].present?
          hash[:remote_files] = new_remote_files if new_remote_files.present?
          hash
        end
      end
    end
  end
end
