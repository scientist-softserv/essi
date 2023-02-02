# modified from Bulkrax::FileFactory
module Extensions
  module Bulkrax
    module ObjectFactory
      module FileFactoryMetadata
        # modified to include :metadata, if available, in :uploaded_files
        def file_attributes(update_files = false)
          @update_files = update_files
          hash = {}
          return hash if klass == Collection
          hash[:uploaded_files] = upload_ids if attributes[:file].present?
          if attributes[:file_metadata].present?
            hash[:uploaded_files] = hash[:uploaded_files].map { |id| { id: id } }
            hash[:uploaded_files].each_with_index do |h, i|
              h[:metadata] = attributes[:file_metadata][i]
            end
          end
          hash[:remote_files] = new_remote_files if new_remote_files.present?
          hash
        end
      end
    end
  end
end
