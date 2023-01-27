# unmodified from hyrax
module Extensions
  module AttachFilesToWorkWithOrderedMembersJob
    module ImportMetadata

      # @param [ActiveFedora::Base] work - the work object
      # @param [Array<Hyrax::UploadedFile>] uploaded_files - an array of files to attach
      def perform(work, uploaded_files, **work_attributes)
        super
      end

      private
    
        def add_uploaded_files(user, metadata, work)
          work_permissions = work.permissions.map(&:to_hash)
          uploaded_files.each do |uploaded_file|
            actor = file_set_actor_class.new(FileSet.create, user)
            actor.create_metadata(metadata)
            actor.create_content(uploaded_file)
            actor.attach_to_work(work)
            actor.file_set.permissions_attributes = work_permissions
            ordered_members << actor.file_set
            uploaded_file.update(file_set_uri: actor.file_set.uri)
          end
        end
    end
  end
end
