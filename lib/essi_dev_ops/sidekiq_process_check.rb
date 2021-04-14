module EssiDevOps
  # Performs a Sidekiq process health check. Uses the same method as the
  # Sidekiq dashboard to discover processes.
  include OkComputer
  class SidekiqProcessCheck < Check
    # Public: Return the status of the Sidekiq processes
    def check
      if running? # rubocop:disable Style/GuardClause
        mark_message "Sidekiq is up"
      else
        raise ConnectionFailed, "No Sidekiq processes found"
      end
    rescue => e # rubocop:disable Lint/RescueWithoutErrorClass
      mark_failure
      mark_message e
    end

    def running?
      Sidekiq::ProcessSet.new.any?
    end
  end
end
