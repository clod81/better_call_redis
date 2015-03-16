require "better_call_redis/version"
require "better_call_redis/configuration"
require "better_call_redis/active_record"

module BetterCallRedis

  class << self
    def configure
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

end
