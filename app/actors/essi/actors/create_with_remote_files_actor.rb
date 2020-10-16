module ESSI
  module Actors
    # If there is a key `:remote_files' in the attributes, it attaches the files at the specified URIs
    # to the work. e.g.:
    #     attributes[:remote_files] = filenames.map do |name|
    #       { url: "https://example.com/file/#{name}", file_name: name }
    #     end
    #
    # Browse everything may also return a local file. And although it's in the
    # url property, it may have spaces, and not be a valid URI.
    class CreateWithRemoteFilesActor < Hyrax::Actors::AbstractActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        remote_files = env.attributes.delete(:remote_files)
        structure = env.attributes.delete(:structure)&.deep_symbolize_keys
        next_actor.create(env) && attach_files(env, remote_files) && save_structure(env, structure)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        remote_files = env.attributes.delete(:remote_files)
        structure = env.attributes.delete(:structure)&.deep_symbolize_keys
        next_actor.update(env) && attach_files(env, remote_files) && save_structure(env, structure)
      end

      private

        def whitelisted_ingest_dirs
          Hyrax.config.whitelisted_ingest_dirs
        end

        # @param uri [URI] the uri fo the resource to import
        def validate_remote_url(uri)
          if uri.scheme == 'file'
            path = File.absolute_path(CGI.unescape(uri.path))
            whitelisted_ingest_dirs.any? do |dir|
              path.start_with?(dir) && path.length > dir.length
            end
          else
            # TODO: It might be a good idea to validate other URLs as well.
            #       The server can probably access URLs the user can't.
            true
          end
        end

        # @param [HashWithIndifferentAccess] remote_files
        # @return [TrueClass]
        def attach_files(env, remote_files)
          return true unless remote_files
          @file_sets = []
          remote_files.each do |file_info|
            next if file_info.blank? || file_info[:url].blank?
            # Escape any space characters, so that this is a legal URI
            uri = URI.parse(Addressable::URI.normalized_encode(file_info[:url]))
            unless validate_remote_url(uri)
              Rails.logger.error "User #{env.user.user_key} attempted to ingest file from url #{file_info[:url]}, which doesn't pass validation"
              return false
            end
            auth_header = file_info.fetch(:auth_header, {})
            create_file_from_url(env, uri, file_info, auth_header)
          end
          MembershipBuilder.new(env.curation_concern, @file_sets).attach_files_to_work
          true
        end

        # Generic utility for creating FileSet from a URL
        # Used in to import files using URLs from a file picker like browse_everything
        def create_file_from_url(env, uri, file_info, auth_header = {})
          ::FileSet.new(import_url: uri.to_s, label: file_info[:file_name]) do |fs|
            actor = Hyrax::Actors::FileSetActor.new(fs, env.user)
# TODO: add more metadata
# TODO: reconsider visibility
            actor.create_metadata(visibility: env.curation_concern.visibility)
            fs.save!
            # TODO: add option for batch vs single assignment?
            @file_sets << fs
            structure_to_repo_map[file_info[:id]] = fs.id
            if uri.scheme == 'file'
              # Turn any %20 into spaces.
              file_path = CGI.unescape(uri.path)
              IngestLocalFileJob.perform_later(fs, file_path, env.user)
            else
              ImportUrlJob.perform_later(fs, operation_for(user: actor.user), auth_header)
            end
          end
        end

        def save_structure(env, structure)
          if structure.present?
            field_map = map_fileids(structure)
            SaveStructureJob.perform_now(env.curation_concern, field_map.to_json)
          end
          true
        end

        def operation_for(user:)
          Hyrax::Operation.create!(user: user,
                                   operation_type: "Attach Remote File")
        end

        def map_fileids(hsh)
          hsh.each do |k, v|
            hsh[k] = v.each { |node| map_fileids(node) } if k == :nodes
            if k == :proxy
              hsh[k] = structure_to_repo_map[v]
              hsh[:label] = "#{v} (missing file)" if !structure_to_repo_map[v]
            end
          end
        end
    
        def structure_to_repo_map
          @structure_to_repo_map ||= {}
        end
    end
  end
end
