# If config value for mount_at set, then OkComputer will mount a route at that location,
# otherwise it is effectively disabled
OkComputer.mount_at = ESSI.config.dig(:okcomputer, :mount_at) || false

if ESSI.config.dig(:okcomputer, :user)
  OkComputer.require_authentication(ESSI.config.dig(:okcomputer, :user),
                                    ESSI.config.dig(:okcomputer, :password))
end

# For built-in checks, see
# https://github.com/sportngin/okcomputer/tree/master/lib/ok_computer/built_in_checks

# Following checks execute after full initialization so that backend
# configuration values are available
Rails.application.configure do
  config.after_initialize do
    checks = OkComputer::CheckCollection.new("Standard Checks")
    OkComputer::Registry.register "default", checks

    checks.register "rails", OkComputer::DefaultCheck.new
    checks.register "database", OkComputer::ActiveRecordCheck.new

    redis_url = ESSI.config[:redis][:rails][:url]
    checks.register "redis", OkComputer::RedisCheck.new(url: redis_url)

    checks.register "sidekiq", EssiDevOps::SidekiqProcessCheck.new

    checks.register "ruby", OkComputer::RubyVersionCheck.new

    checks.register "cache", OkComputer::GenericCacheCheck.new

    iiif_url = ESSI.config[:cantaloupe][:iiif_server_url]
    checks.register "iiif", OkComputer::HttpCheck.new(iiif_url)

    solr_url = ESSI.config[:solr][:url]
    checks.register "solr", OkComputer::SolrCheck.new(solr_url)

    fcrepo_url = ESSI.config[:fedora][:url]
    fcrepo_user = ESSI.config[:fedora][:user]
    fcrepo_password = ESSI.config[:fedora][:password]
    auth_options = [fcrepo_user, fcrepo_password]
    checks.register "fcrepo", EssiDevOps::FcrepoCheck.new(fcrepo_url, 10,
                                                        auth_options)

    # TODO: Remove this when CheckCollection instances not setting
    # registrant_name is fixed.
    checks.collection.each do |check_name, check_obj|
      check_obj.registrant_name = check_name
    end
  end
end
