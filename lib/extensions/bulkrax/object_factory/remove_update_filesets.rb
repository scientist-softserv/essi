module Extensions
  module Bulkrax
    module ObjectFactory
      module RemoveUpdateFilesets
        # modifies an existing fileset, injecting an additional File into the first file
        def modify_fileset(fileset:, original_name:, mime_type:, file_path:)
          fileset.files.first.create_version
          opts = {}
          opts[:path] = fileset.files.first.id.split('/', 2).last
          opts[:original_name] = original_name
          opts[:mime_type] = mime_type

          fileset.add_file(::File.open(file_path), opts)
          fileset.save
          ::CreateDerivativesJob.set(wait: 1.minute).perform_later(fileset, fileset.files.first.id)
          nil
        end

        # modified from bulkrax: uses helper method
        def set_removed_filesets
          local_file_sets.each do |fileset|
            modify_fileset(fileset: fileset,
                           original_name: 'removed.png',
                           mime_type: 'image/png',
                           file_path: ::Bulkrax.removed_image_path)
          end
        end

        # modified from bulkrax: uses helper method
        def update_filesets(current_file)
          if @update_files && local_file_sets.present?
            fileset = local_file_sets.shift
            return nil if fileset.files.first.checksum.value == Digest::SHA1.file(current_file.file.path).to_s
   
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
