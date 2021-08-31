module Extensions
  module Bulkrax
    module ObjectFactory
      module RemoveUpdateFilesets
        # unmodified from bulkrax FileFactory
        def set_removed_filesets
          local_file_sets.each do |fileset|
            fileset.files.first.create_version
            opts = {}
            opts[:path] = fileset.files.first.id.split('/', 2).last
            opts[:original_name] = 'removed.png'
            opts[:mime_type] = 'image/png'
    
            fileset.add_file(::File.open(::Bulkrax.removed_image_path), opts)
            fileset.save
            ::CreateDerivativesJob.set(wait: 1.minute).perform_later(fileset, fileset.files.first.id)
          end
        end

        # unmodified from bulkrax FileFactory
        def update_filesets(current_file)
          if @update_files && local_file_sets.present?
            fileset = local_file_sets.shift
            return nil if fileset.files.first.checksum.value == Digest::SHA1.file(current_file.file.path).to_s
    
            fileset.files.first.create_version
            opts = {}
            opts[:path] = fileset.files.first.id.split('/', 2).last
            opts[:original_name] = current_file.file.file.original_filename
            opts[:mime_type] = current_file.file.content_type
    
            fileset.add_file(File.open(current_file.file.to_s), opts)
            fileset.save
            ::CreateDerivativesJob.set(wait: 1.minute).perform_later(fileset, fileset.files.first.id)
            nil
          else
            current_file.save
            current_file.id
          end
        end
      end
    end
  end
end
