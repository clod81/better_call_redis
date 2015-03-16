module BetterCallRedis
  class Configuration

    attr_writer :redis
    attr_writer :namespace
    attr_writer :deleted_attributes

    def redis
      @redis ||= Redis.new
    end

    def namespace
      @namespace ||= "bettercallredis:notification"
    end

    def deleted_attributes
      @deleted_attributes ||= []
    end

  end
end
