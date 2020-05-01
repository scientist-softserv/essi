# Override the stock actor for #ingest_file
module Hyrax
  module Actors
    # Actions for a file identified by file_set and relation (maps to use predicate)
    # @note Spawns asynchronous jobs
    class FileActor
      attr_reader :file_set, :relation, :user

      # @param [FileSet] file_set the parent FileSet
      # @param [Symbol, #to_sym] relation the type/use for the file
      # @param [User] user the user to record as the Agent acting upon the file
      def initialize(file_set, relation, user)
        @file_set = file_set
        @relation = relation.to_sym
        @user = user
      end

      # Persists file as part of file_set and spawns async job to characterize and create derivatives.
      # @param [JobIoWrapper] io the file to save in the repository, with mime_type and original_name
      # @return [CharacterizeJob, FalseClass] spawned job on success, false on failure
      # @note Instead of calling this method, use IngestJob to avoid synchronous execution cost
      # @see IngestJob
      # @todo create a job to monitor the temp directory (or in a multi-worker system, directories!) to prune old files that have made it into the repo
      def ingest_file(io)
        # FIXME: pass along mimetype, filename options?
        if store_files?
          Hydra::Works::AddFileToFileSet.call(file_set,
                                              io,
                                              relation,
                                              versioning: false)
        else
          Hydra::Works::AddExternalFileToFileSet.call(file_set,
                                                      master_file_service_url,
                                                      relation,
                                                      versioning: false)
        end
        return false unless file_set.save
        repository_file = related_file
        Hyrax::VersioningService.create(repository_file, user)
        pathhint = io.uploaded_file.uploader.path if io.uploaded_file # in case next worker is on same filesystem
        CharacterizeJob.perform_later(file_set, repository_file.id, pathhint || io.path) if characterize_files?(file_set)
      end

      # Reverts file and spawns async job to characterize and create derivatives.
      # @param [String] revision_id
      # @return [CharacterizeJob, FalseClass] spawned job on success, false on failure
      def revert_to(revision_id)
        repository_file = related_file
        repository_file.restore_version(revision_id)
        return false unless file_set.save
        Hyrax::VersioningService.create(repository_file, user)
        CharacterizeJob.perform_later(file_set, repository_file.id) if characterize_files?(file_set)
      end

      # @note FileSet comparison is limited to IDs, but this should be sufficient, given that
      #   most operations here are on the other side of async retrieval in Jobs (based solely on ID).
      def ==(other)
        return false unless other.is_a?(self.class)
        file_set.id == other.file_set.id && relation == other.relation && user == other.user
      end

      private

        # @return [Hydra::PCDM::File] the file referenced by relation
        def related_file
          file_set.public_send(relation) || raise("No #{relation} returned for FileSet #{file_set.id}")
        end

        def characterize_files?(file_set)
          store_files? && !file_set.collection_branding?
        end

        def store_files?
          ESSI.config.dig :essi, :store_original_files
        end
    
        def master_file_service_url
          ESSI.config.dig :essi, :master_file_service_url
        end
    end
  end
end
