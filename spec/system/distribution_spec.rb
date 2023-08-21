require "spec_helper"
require "tasks/distribution"

describe "Distribution" do
  context "#new" do
    it "creates a dist folder" do
      Distribution.new
      expect(Dir.exist?("#{Dir.pwd}/dist")).to be(true)
    end

    it "creates css from assets" do
      Distribution.new
      expect(File.exist?("#{Dir.pwd}/dist/css/honeycrisp.css")).to be(true)
    end

    it "creates css sourcemaps from assets" do
      Distribution.new
      expect(File.exist?("#{Dir.pwd}/dist/css/honeycrisp.css.map")).to be(true)
    end

    context "minified css" do
      it "creates minified css from assets" do
        Distribution.new
        expect(File.exist?("#{Dir.pwd}/dist/css/honeycrisp.min.css")).to be(true)
      end

      it "adds version and date comment to minifed css" do
        version_comment = "Honeycrisp v#{Cfa::Styleguide::VERSION} built on #{Date.today}"
        Distribution.new

        expect(File.readlines("#{Dir.pwd}/dist/css/honeycrisp.min.css")[0].include?(version_comment)).to be(true)
      end
    end

    it "creates css sourcemaps from assets" do
      Distribution.new
      expect(File.exist?("#{Dir.pwd}/dist/css/honeycrisp.min.css.map")).to be(true)
    end

    it "copies js from assets" do
      Distribution.new
      expect(File.exist?("#{Dir.pwd}/dist/js/honeycrisp.js")).to be(true)
    end

    context "minified js" do
      it "creates minified js from assets" do
        Distribution.new
        expect(File.exist?("#{Dir.pwd}/dist/js/honeycrisp.min.js")).to be(true)
      end

      it "adds version and date comment to minifed js" do
        version_comment = "Honeycrisp v#{Cfa::Styleguide::VERSION} built on #{Date.today}"
        Distribution.new

        expect(File.readlines("#{Dir.pwd}/dist/js/honeycrisp.min.js")[0].include?(version_comment)).to be(true)
      end
    end

    it "creates js source map from assets" do
      Distribution.new
      expect(File.exist?("#{Dir.pwd}/dist/js/honeycrisp.min.js.map")).to be(true)
    end
  end

  context "#add_version_comment" do
    it "replaces placeholder with version and date" do
      my_distribution = Distribution.new
      css = "/* Honeycrisp version placeholder */ body { background: white;}"
      result = my_distribution.send(:add_version_comment, css)

      expect(result).not_to include("Honeycrisp version placeholder")
      expect(result).to include("Honeycrisp v#{Cfa::Styleguide::VERSION} built on #{Date.today}")
    end
  end
end
