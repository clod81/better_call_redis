module BetterCallRedis
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end

  private

    def better_call_redis_notify_redis_created
      better_call_redis_notify(1)
    end

    def better_call_redis_notify_redis_removed
      better_call_redis_notify(-1)
    end

    def better_call_redis_logically_delete
      return if self.new_record?
      return unless common_deleted_attribute = self.class.better_call_redis_common_deleted_attribute
      return unless self.send("#{common_deleted_attribute}_changed?")
      self.send("#{common_deleted_attribute}") ? better_call_redis_notify_redis_removed : better_call_redis_notify_redis_created
    end

    def better_call_redis_notify(action)
      self.class.better_call_redis_configuration.redis.publish(self.class.better_call_redis_configuration.namespace, {:class_name => self.class.name, :message => action}.to_json)
    end

    module ClassMethods

      def self.extended(base)
        base.class_eval do
          before_save   :better_call_redis_logically_delete
          after_create  :better_call_redis_notify_redis_created
          after_destroy :better_call_redis_notify_redis_removed
        end

        def better_call_redis_configuration
          BetterCallRedis.configuration
        end

        def better_call_redis_common_deleted_attribute
          (new.attributes.keys & better_call_redis_configuration.deleted_attributes).first
        end

        def better_call_redis_count
          common_deleted_attribute = better_call_redis_common_deleted_attribute
          return where("#{common_deleted_attribute} != true").count if common_deleted_attribute
          count
        end

      end # end extended

    end # end ClassMethods

  end
end
