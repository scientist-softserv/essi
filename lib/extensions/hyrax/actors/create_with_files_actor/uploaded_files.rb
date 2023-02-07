# modified from hyrax
module Extensions
  module Hyrax
    module Actors
      module CreateWithFilesActor
        module UploadedFiles
          private
            # modified to process raw ids or Hashes of :id, :metadata
            # Fetch uploaded_files from the database
            # @param [Integer, Hash] uploaded_file_ids as raw ids or Hash of :id, :metadata values
            # @return [Array<Hyrax::UploadedFile]] array of uploaded files
            def uploaded_files(uploaded_file_ids)
              return [] if uploaded_file_ids.empty?
              case uploaded_file_ids.first
              when String, Integer
                ::Hyrax::UploadedFile.find(uploaded_file_ids)
              when Hash
                uploaded_file_ids.map do |hash|
                  uploaded_file = ::Hyrax::UploadedFile.find(hash[:id])
                  uploaded_file.metadata = hash[:metadata]
                  uploaded_file
                end
              else
                []
              end
            end 
        end
      end
    end
  end
end
