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
        infer_source_metadata_identifier(file_set, io)
        if store_files?
          if transform_to_jp2?(io)
            # use original .tiff for derivatives
            derivation_path = pathhint_for(io)
            transform_to_jp2(file_set, io)
            # use transformed .jp2 for characterization
            characterization_path = io.path
          end

          Hydra::Works::AddFileToFileSet.call(file_set,
                                              io,
                                              relation,
                                              versioning: false)
        end
        if store_masters?
          url = master_url_for_file_set(file_set) || master_file_service_url
          file_use = (store_files? ? :preservation_master_file : :original_file)
          Hydra::Works::AddExternalFileToFileSet.call(file_set,
                                                      url,
                                                      file_use,
                                                      versioning: false)
        end
        return false unless file_set.save
        repository_file = related_file
        Hyrax::VersioningService.create(repository_file, user)
        characterization_path ||= pathhint_for(io)
        derivation_path ||= pathhint_for(io)
        CharacterizeJob.perform_later(file_set, repository_file.id, characterization_path, derivation_path) if characterize_files?(file_set)
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

        def infer_source_metadata_identifier(file_set, io)
          if file_set.source_metadata_identifier.blank? && io.path.present?
            file_set.source_metadata_identifier = File.basename(io.path, File.extname(io.path))
          end
        end

        def master_file_service_url
          ESSI.config.dig :essi, :master_file_service_url
        end

        def master_url_for_file_set(file_set)
          return nil unless master_file_service_url.present?
          return nil unless file_set.source_metadata_identifier.present?
          master_file_service_url + '/' + file_set.source_metadata_identifier
        end

        def store_files?
          ESSI.config.dig :essi, :store_original_files
        end

        def store_masters?
          master_file_service_url.present?
        end

        def transform_to_jp2?(io)
          # FIXME: only transform tiffs?
          ESSI.config.dig(:essi, :store_files_as_jp2) && io.path.match(/\.tif+$/)
        end

        def transform_to_jp2(file_set, io)
          original_path = io.path
          new_file = File.basename(original_path).sub(/\.tif+$/, '.jp2')
          new_path = "#{Dir.mktmpdir}/#{new_file}"
          file_set.label = new_file
          file_set.title = [new_file]
          if Hydra::Derivatives.kdu_compress_path.present?
            url = URI("file://#{new_path}").to_s
            # FIXME: chokes on compressed tiffs
            # FIXME: chokes on small tiffs that generate a negative compression value
            Hydra::Derivatives::Jpeg2kImageDerivatives.create(original_path, { outputs: [ url: url, recipe: :default ]})
          else
            MiniMagick::Tool::Convert.new do |convert|
              convert << original_path
              convert << new_path
            end
          end
          io.path = new_path
          io.mime_type = MIME::Types.type_for('jp2').first.to_s
        end

        def pathhint_for(io)
          return io.uploaded_file.uploader.path if io.uploaded_file # in case next worker is on same filesystem
          io.path
        end
    end
  end
end
