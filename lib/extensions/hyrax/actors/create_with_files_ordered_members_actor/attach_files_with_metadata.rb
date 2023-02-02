# modified from hyrax
module Extensions
  module Hyrax
    module Actors
      module CreateWithFilesOrderedMembersActor
        module AttachFilesWithMetadata
          # modified to pass files metadata to job
          # @return [TrueClass]
          def attach_files(files, env)
            return true if files.blank?
            # UploadedFile objects have metadata values, but they seem to be dropped when passed to the job
            # workaround is storing them in the attributes argument, where they get retained
            files_metadata = { files_metadata: files.map { |f| f.metadata || {} } }
            ::AttachFilesToWorkWithOrderedMembersJob.perform_later(env.curation_concern, files, env.attributes.to_h.merge(files_metadata).symbolize_keys)
            true
          end
        end
      end
    end
  end
end
