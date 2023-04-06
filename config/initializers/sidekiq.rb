# Sidekiq normally sets options from (Rails.root)/config/sidekiq.yml. This initializer allows us to set
# configuration options that may have been overridden using the ESSI configuration YAML file.

redis_config = ESSI.config[:redis][:sidekiq]

Sidekiq.configure_server do |c|
  c.redis = redis_config
end

Sidekiq.configure_client do |c|
  c.redis = redis_config
end

# Retrieve Sidekiq options set in the default configuration file
sidekiq_config = YAML.safe_load(ERB.new(IO.read(Rails.root.join('config', 'sidekiq.yml'))).result,[Symbol], [], true)

# The following calls to Sidekiq.options establishes the following order of precedence:
# 1. The named option is set from the ESSI configuration file if exists
# 2. Or the named option is set from the default Sidekiq YAML configuration file if exists
# 3. Or no options are set and Sidekiq defaults to internal defaults

# The environment variable SIDEKIQ_QUEUES takes priority when setting the monitored queues.
# If no queue names are set in either the ENV var, the ESSI or Sidekiq config files, the queue
# will be set to the Sidekiq internal of default.
env_queues = ENV.fetch('SIDEKIQ_QUEUES', '').split(',')
Sidekiq.options[:queues] = (env_queues.empty? ? nil : env_queues) ||
  ESSI.config.fetch(:sidekiq,{}).fetch(:queue_names,nil) ||
  sidekiq_config.fetch(:queues,['default']) if sidekiq_config

# If max_retries is not set in either the ESSI or Sidekiq config files, the value
# will be set to the Sidekiq internal default (10?)
Sidekiq.options[:max_retries] = ESSI.config.fetch(:sidekiq,{}).fetch(:max_retries,nil) ||
  sidekiq_config.fetch(:max_retries,3) if sidekiq_config
