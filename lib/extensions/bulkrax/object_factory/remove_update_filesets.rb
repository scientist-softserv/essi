module Extensions
  module Bulkrax
    module ObjectFactory
      module RemoveUpdateFilesets
        delegate :characterize_files?, :store_files?, to: ::Hyrax::Actors::FileActor

        # modifies an existing fileset, injecting an additional File into original_file
        def modify_fileset(fileset:, original_name:, mime_type:, file_path:)
          original_file = fileset.original_file
          return unless original_file
          original_file.create_version
          opts = {}
          opts[:path] = original_file.id.split('/', 2).last
          opts[:original_name] = original_name
          opts[:mime_type] = mime_type

          fileset.add_file(::File.open(file_path), opts)
          fileset.save
          ::CharacterizeJob.set(wait: 1.minute).perform_later(fileset, original_file.id) if characterize_files?(fileset)
          nil
        end

        # modified from bulkrax: uses helper method, original_file use, Job logic as in FileActor
        def set_removed_filesets
          local_file_sets.each do |fileset|
            modify_fileset(fileset: fileset,
                           original_name: 'removed.png',
                           mime_type: 'image/png',
                           file_path: ::Bulkrax.removed_image_path)
          end
        end

        # modified from bulkrax: uses helper method, original_file use, Job logic as in FileActor
        def update_filesets(current_file)
          if @update_files && local_file_sets.present?
            fileset = local_file_sets.shift
            return nil if fileset.original_file&.checksum&.value == Digest::SHA1.file(current_file.file.path).to_s
   
            modify_fileset(fileset: fileset,
                           original_name: current_file.file.file.original_filename,
                           content_type: current_file.file.content_type,
                           file_path: current_file.file.to_s) 
          else
            current_file.save
            current_file.id
          end
        end
      end
    end
  end
end
