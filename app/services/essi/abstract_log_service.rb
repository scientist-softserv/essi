module ESSI
  class AbstractLogService
    attr_reader :file_set, :user, :path

    def initialize(file_set, user, path)
      @file_set = file_set
      @user = user
      @path = path
    end

    def call
      service_logger.send(type, message)
    end

    def service_logger
      @service_logger ||= ::Logger.new(ESSI.config.dig(:essi, :service_log))
    end

    # @return [String]
    def message
      raise "Override #message in the service class"
    end

    # @return [Symbol, String] Log severity level: debug, info, warn, error, fatal, any
    def type
      raise "Override #type in the service class"
    end
  end
end
