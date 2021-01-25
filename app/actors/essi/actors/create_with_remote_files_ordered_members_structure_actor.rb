module ESSI
  module Actors
    class CreateWithRemoteFilesOrderedMembersStructureActor < CreateWithRemoteFilesActor
      def create(env)
        Rails.logger.debug "Called ESSI::Actors::CreateWithRemoteFilesOrderedMembersStructureActor#create for #{env.curation_concern.id}"
        structure = env.attributes.delete(:structure)&.deep_symbolize_keys
        super(env) && save_structure(env,structure) && copy_visibility(env) && inherit_permissions(env)
      end

      def update(env)
        structure = env.attributes.delete(:structure)&.deep_symbolize_keys
        super(env) && save_structure(env,structure)
      end

      private

        # @param [HashWithIndifferentAccess] remote_files
        # @return [TrueClass]
        def attach_files(env, remote_files)
          return true unless remote_files
          env.store(self, :ordered_members, env.curation_concern.ordered_members.to_a)
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
          add_ordered_members(env)

          # Method used in old version of this actor.
          # MembershipBuilder.new(env.curation_concern, @file_sets).attach_files_to_work

          true
        end

        # Generic utility for creating FileSet from a URL
        # Used in to import files using URLs from a file picker like browse_everything
        def create_file_from_url(env, uri, file_info, auth_header = {})
          ::FileSet.new(import_url: uri.to_s, label: file_info[:file_name]) do |fs|
            actor = file_set_actor_class.new(fs, env.user)
            # TODO: add more metadata
            # TODO: reconsider visibility
            actor.create_metadata(visibility: env.curation_concern.visibility)
            actor.attach_to_work(env.curation_concern)
            fs.save!
            # TODO: add option for batch vs single assignment?
            env.retrieve(self, :ordered_members) << fs
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

        # Add all file_sets as ordered_members in a single action
        def add_ordered_members(env)
          actor = Hyrax::Actors::OrderedMembersActor.new(env.retrieve(self, :ordered_members), env.user)
          actor.attach_ordered_members_to_work(env.curation_concern)
        end

        class_attribute :file_set_actor_class
        self.file_set_actor_class = Hyrax::Actors::FileSetOrderedMembersActor

        def save_structure(env, structure)
          if structure.present?
            field_map = map_fileids(structure)
            SaveStructureJob.perform_now(env.curation_concern, field_map.to_json)
          end
          true
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

      def copy_visibility(env)
        VisibilityCopyJob.perform_later(env.curation_concern)
      end

      def inherit_permissions(env)
        InheritPermissionsJob.perform_later(env.curation_concern)
      end

    end
  end
end
