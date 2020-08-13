require 'action_cable/subscription_adapter/redis'

# Enable reconnect to redis to reduce disconnection issues with ActionCable PubSub
ActionCable::SubscriptionAdapter::Redis.redis_connector = lambda do |config|
  redis_opts = { url: config[:url] }
  redis_opts[:reconnect_attempts] = 5
  redis_opts[:reconnect_delay] = 0.5
  redis_opts[:reconnect_delay_max] = 5
  ::Redis.new(redis_opts)
end
