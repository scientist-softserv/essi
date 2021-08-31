class BagWorkJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  def perform(identifier, dropbox_path = nil, bags_path = nil, bag_info = {})
    if dropbox_path.nil?
      dropbox_path = File.join(ESSI.config.dig(:essi, :bagit, :default_upload_dropbox), identifier)
    end
    return unless Dir.exist?(dropbox_path)
    bags_path = ESSI.config.dig(:essi, :bagit, :default_bagit_dir) unless bags_path
    bag_path = File.join(bags_path, identifier)

    if File.exist?(bag_path)
      bag = BagIt::Bag.new(File.join(bag_path))
      if bag.valid?
        bag.bag_files.each do |f|
          Rails.logger.info "Removing #{f} from #{bag.data_dir}"
          FileUtils.rm(f) if File.exist?(f)
        end
      end
    end
    bag = BagIt::Bag.new(File.join(bag_path), bag_info)
    Dir.foreach(dropbox_path) do |filename|
      next if filename == '.' or filename == '..'
      Rails.logger.info "Adding #{filename} to #{bag_path} from " + File.join(dropbox_path, filename)
      bag.add_file(filename, File.join(dropbox_path, filename))
    end
    # The manifest! method will recreate all manifest/tag files since we may have overwritten data files
    bag.manifest!(algo: 'sha256')
  end
end
