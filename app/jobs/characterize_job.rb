class CharacterizeJob < ApplicationJob
  queue_as Hyrax.config.ingest_queue_name

  # Characterizes the file at 'filepath' if available, otherwise, pulls a copy from the repository
  # and runs characterization on that file.
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
  # @param [FalseClass, TrueClass, String, NilClass] delete_characterization_path triggers deleting the file on any truthy value, and the parent directory on 'include_parent_dir'
  def perform(file_set, file_id, filepath = nil, derivation_path = nil, delete_characterization_path = false)
    raise "#{file_set.class.characterization_proxy} was not found for FileSet #{file_set.id}" unless file_set.characterization_proxy?
    unless filepath && File.exist?(filepath)
      filepath = Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id) unless filepath && File.exist?(filepath)
      delete_characterization_path = false
    end
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filepath)
    Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} (#{file_set.characterization_proxy.mime_type})"
    file_set.characterization_proxy.save!
    file_set.update_index
    file_set.parent&.in_collections&.each(&:update_index)
    derivation_path = filepath unless derivation_path && File.exist?(derivation_path)
    CreateDerivativesJob.perform_later(file_set, file_id, derivation_path)
    unlink_filepath(filepath, delete_characterization_path.to_s) if delete_characterization_path
  end

  # Removes characterization file and optionally parent directory
  # @param [String] filepath file to unlink
  # @param [String, NilClass] options option to remove parent directory
  def unlink_filepath(filepath, options = nil)
    File.unlink(filepath)
    Dir.rmdir(File.dirname(filepath)) if options == 'include_parent_dir'
  end
end

