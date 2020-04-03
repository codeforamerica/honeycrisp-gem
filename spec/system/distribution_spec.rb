require "spec_helper"
require "tasks/distribution"

describe "Distribution" do
  before :each do
    FileUtils.rm_rf(%W(#{Dir.pwd}/dist #{Dir.pwd}.sass-cache #{Dir.pwd}/tmp))
  end

  context "#new" do
    it "creates a dist folder" do
      Distribution.new
      expect(Dir.exist?(Dir.pwd + "/dist")).to be(true)
    end

    it "creates css from assets" do
      Distribution.new
      expect(File.exist?(Dir.pwd + "/dist/css/honeycrisp.css")).to be(true)
    end

    it "creates minified css from assets" do
      Distribution.new
      expect(File.exist?(Dir.pwd + "/dist/css/honeycrisp.min.css")).to be(true)
    end

    it "copies js from assets" do
      Distribution.new
      expect(File.exist?(Dir.pwd + "/dist/js/honeycrisp.js")).to be(true)
    end

    it "creates minified js from assets" do
      Distribution.new
      expect(File.exist?(Dir.pwd + "/dist/js/honeycrisp.min.js")).to be(true)
    end

    it "creates js source map from assets" do
      Distribution.new
      expect(File.exist?(Dir.pwd + "/dist/js/honeycrisp.min.js.map")).to be(true)
    end
  end
end
