# unmodified from hyrax
module Extensions
  module Hyrax
    module Actors
      module CreateWithFilesActor
        module UploadedFiles
          private
            # Fetch uploaded_files from the database
            # @param [Integer] uploaded_file_ids
            # @return [Array<Hyrax::UploadedFile]] array of uploaded files
            def uploaded_files(uploaded_file_ids)
              return [] if uploaded_file_ids.empty?
              ::Hyrax::UploadedFile.find(uploaded_file_ids)
            end 
        end
      end
    end
  end
end
