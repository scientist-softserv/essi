module ESSI
  class ImportLocalFileSuccessService < AbstractLogService

    def message
      id = file_set&.id || '(id missing)'
      uri = file_set&.original_file&.uri&.to_s || '(URI missing)'
      file_title = file_set&.title&.first || '(title missing)'
      "The local file import job run by user #{user&.uid} (#{user&.email}) for '#{file_title}' (#{id}, #{uri}) from #{path} succeeded."
    end

    def type
      :info
    end
  end
end
