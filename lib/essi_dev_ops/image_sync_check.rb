module EssiDevOps
  # Checks to make sure images are running the same commit level when jobs/admin are distributed across servers
  include OkComputer
  class ImageSyncCheck < Check
    @admin_image_commit = 'NA'
    @jobs_image_commit = 'NA'

    def check
      retrieve_image_commits
      if images_in_sync? # rubocop:disable Style/GuardClause
        mark_message 'Deployed images are in sync'
      else
        raise StandardError, images_out_of_sync
      end
    rescue StandardError => e
      mark_failure
      mark_message e
    end

    def retrieve_image_commits
      admin_image_file = File.read('/run/secrets/inspect_image-admin.json')
      jobs_image_file = File.read('/run/secrets/inspect_image-jobs.json')
      admin_image_data = JSON.parse(admin_image_file)
      jobs_image_data = JSON.parse(jobs_image_file)

      @admin_image_commit = parse_image_data(admin_image_data)
      @jobs_image_commit = parse_image_data(jobs_image_data)
    end

    def parse_image_data(image_data)
      image_env = image_data.dig(0, 'Config', 'Env')
      image_commit = image_env.find { |env| env.include?('SOURCE') }
      _key, value = image_commit.split '='
      value
    end

    def images_in_sync?
      @admin_image_commit == @jobs_image_commit
    end

    def images_out_of_sync
      admin_abbr = @admin_image_commit[0, 7]
      jobs_abbr = @jobs_image_commit[0, 7]
      "The admin image at #{admin_abbr} is different than job image at #{jobs_abbr}"
    end
  end
end
