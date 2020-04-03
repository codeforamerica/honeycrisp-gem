require "fileutils"
require "sass"
require "sprockets_extension/uglifier_source_maps_compressor"

class Distribution
  def initialize
    create_directories
    install_dependencies
    compile_css
    compile_js
  end

  private

  def create_directories
    FileUtils.mkdir_p(Dir.pwd + "/dist")
    FileUtils.mkdir_p("/tmp/neat")
  end

  def compile_css
    Sass.load_paths << Dir.pwd + "/vendor/assets/stylesheets/" <<
        Dir.pwd + "/tmp/bourbon" <<
        Dir.pwd + "/tmp/neat"
    css_root = Dir.pwd + "/dist/css"
    FileUtils.mkdir_p(css_root)
    Sass.compile_file("#{Dir.pwd}/app/assets/stylesheets/cfa_styleguide_main.scss", css_root + "/honeycrisp.css")
  end

  def compile_js
    sprockets = create_sprockets_env
    js_assets = "#{Dir.pwd}/app/assets/javascripts/cfa_styleguide_main.js"
    assets = sprockets.find_asset(js_assets)
    assets.write_to("#{Dir.pwd}/dist/js/honeycrisp.js")

    sprockets = create_sprockets_env(compress: true)
    assets = sprockets.find_asset(js_assets)
    assets.write_to("#{Dir.pwd}/dist/js/honeycrisp.min.js")
  end

  def jquery_path
    $LOAD_PATH.detect do |path|
      path.match(/jquery-rails(.*)\/vendor/)
    end
  end

  def create_sprockets_env(compress: false)
    Sprockets::Environment.new do |env|
      env.js_compressor = :uglify_with_source_maps if compress
      env.append_path("#{Dir.pwd}/app/assets/javascripts/")
      env.append_path("#{Dir.pwd}/vendor/assets/javascripts/")
      env.append_path("#{jquery_path}/assets/javascripts/")
    end
  end

  def install_dependencies
    `bourbon install --path tmp && neat install`
    FileUtils.move(Dir.pwd + "/neat", Dir.pwd + "/tmp/neat/")

    Sprockets.register_compressor(
        "application/javascript",
        :uglify_with_source_maps,
        UglifierSourceMapsCompressor,
    )
  end
end
