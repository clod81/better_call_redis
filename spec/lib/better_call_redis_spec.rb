require 'spec_helper'

describe "BetterCallRedis Initializer" do

  describe "with default options" do
    let(:conf) { BetterCallRedis.configuration }
    it "should have all default options" do
      expect(conf.redis).to be_kind_of Redis
      expect(conf.namespace). equal? "bettercallredis:notification"
      expect(conf.deleted_attributes).equal? []
    end
  end

  describe "with non default options" do
    let(:conf) do
      BetterCallRedis.configuration do |bcr|
        bcr.redis              = "Invalid Redis"
        bcr.namespace          = "different"
        bcr.deleted_attributes = %w(deleted cancelled)
      end
    end
    it "should have all default options" do
      expect(conf.redis).equal? "Invalid Redis"
      expect(conf.namespace). equal? "different"
      expect(conf.deleted_attributes).equal? %w(deleted cancelled)
    end
  end

end
