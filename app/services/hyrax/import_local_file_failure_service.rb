module Hyrax
  class ImportLocalFileFailureService < AbstractMessageService
    attr_reader :file_set, :user, :path, :log_date

    def initialize(file_set, user, path)
      @file_set = file_set
      @user = user
      @path = path
      @log_date = Time.now
    end

    def message
      id = file_set&.id || '(id missing)'
      uri = file_set&.original_file&.uri&.to_s || '(URI missing)'
      file_title = file_set&.title&.first || '(title missing)'
      "The local file import job run at #{log_date} for '#{file_title}' (#{id}, #{uri}) from #{path} failed.\nDetails:\n" +
        file_set.errors.full_messages.join("\n")
    end

    def subject
      'Failing Import Local File'
    end
  end
end
