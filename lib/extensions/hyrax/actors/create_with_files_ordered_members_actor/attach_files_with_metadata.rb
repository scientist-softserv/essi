# unmodified from hyrax
module Extensions
  module Hyrax
    module Actors
      module CreateWithFilesOrderedMembersActor
        module AttachFilesWithMetadata
          # @return [TrueClass]
          def attach_files(files, env)
            return true if files.blank?
            ::AttachFilesToWorkWithOrderedMembersJob.perform_later(env.curation_concern, files, env.attributes.to_h.symbolize_keys)
            true
          end
        end
      end
    end
  end
end
