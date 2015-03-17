require 'spec_helper'

describe "BetterCallRedis::ActiveRecord" do

  before(:each) do
    BetterCallRedis.configure do |bcr|
      bcr.namespace          = "test"
      bcr.deleted_attributes = %w(deleted)
    end
    allow(BetterCallRedis.configuration.redis).to receive(:to_str) { "" }
  end

  describe "for a new record" do
    before(:each) do
      @model = Person.new
      allow(@model).to receive(:new_record?) { true }
      allow(@model).to receive(:save) { @model.run_callbacks(:create) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).to receive(:publish).with("test", "{\"class_name\":\"Person\",\"message\":1}") { true }
      @model.save
    end
  end

  describe "for an existing record" do
    before(:each) do
      @model = Person.new
      allow(@model).to receive(:new_record?) { false }
      allow(@model).to receive(:save) { @model.run_callbacks(:save) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).not_to receive(:publish)
      @model.save
    end
  end

  describe "deleting an existing record" do
    before(:each) do
      @model = Person.new
      allow(@model).to receive(:new_record?) { false }
      allow(@model).to receive(:destroy) { @model.run_callbacks(:destroy) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).to receive(:publish).with("test", "{\"class_name\":\"Person\",\"message\":-1}") { true }
      @model.destroy
    end
  end

  describe "logically delete an existing record" do
    before(:each) do
      @model = PersonLogicallyDeletable.new
      allow(@model).to receive(:new_record?) { false }
      allow(@model).to receive(:save) { @model.run_callbacks(:save) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).to receive(:publish).with("test", "{\"class_name\":\"PersonLogicallyDeletable\",\"message\":-1}") { true }
      @model.deleted = true
      @model.save
    end
  end

  describe "logically undelete an existing record" do
    before(:each) do
      @model = PersonLogicallyDelated.new
      allow(@model).to receive(:new_record?) { false }
      allow(@model).to receive(:save) { @model.run_callbacks(:save) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).to receive(:publish).with("test", "{\"class_name\":\"PersonLogicallyDelated\",\"message\":1}") { true }
      @model.deleted = false
      @model.save
    end
  end

  describe "changind a delete attribute not specified in the configuration deleted_attributes" do
    before(:each) do
      @model = PersonLogicallyDelatedNotChanged.new
      allow(@model).to receive(:new_record?) { false }
      allow(@model).to receive(:save) { @model.run_callbacks(:save) }
    end
    it "should call redis with correct params" do
      expect(BetterCallRedis.configuration.redis).not_to receive(:publish)
      @model.cancelled = false
      @model.save
    end
  end

end
