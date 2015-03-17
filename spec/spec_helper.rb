require 'better_call_redis'
require 'redis'
require 'active_record'
require 'active_record/serialization'

class Person
  include ActiveRecord::Callbacks
  include BetterCallRedis::ActiveRecord

  def attributes
    {"id" => 1, "name" => "name_person"}
  end
end


class PersonLogicallyDeletable < Person
  attr_accessor :deleted
  attr_accessor :cancelled

  def attributes
    {"id" => 1, "name" => "name_person", "deleted" => false, "cancelled" => false}
  end

  def deleted_changed?
    true
  end
end

class PersonLogicallyDelated < PersonLogicallyDeletable
  def attributes
    {"id" => 1, "name" => "name_person", "deleted" => true, "cancelled" => true}
  end

  def deleted_changed?
    true
  end
end

class PersonLogicallyDelatedNotChanged < PersonLogicallyDeletable
  def attributes
    {"id" => 1, "name" => "name_person", "deleted" => true, "cancelled" => true}
  end

  def deleted_changed?
    false
  end
end
