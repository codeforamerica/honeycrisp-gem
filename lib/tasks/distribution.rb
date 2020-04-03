require "fileutils"
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
    css_root = Dir.pwd + "/dist/css"
    FileUtils.mkdir_p(css_root)
    sprockets = create_sprockets_env
    assets = sprockets.find_asset("#{Dir.pwd}/app/assets/stylesheets/cfa_styleguide_main.scss")
    assets.write_to(css_root + "/honeycrisp.css")

    sprockets = create_sprockets_env(compress: true)
    assets = sprockets.find_asset("#{Dir.pwd}/app/assets/stylesheets/cfa_styleguide_main.scss")
    assets.write_to(css_root + "/honeycrisp.min.css")
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
      env.css_compressor = :sass if compress
      env.append_path("#{Dir.pwd}/app/assets/javascripts/")
      env.append_path("#{Dir.pwd}/app/assets/stylesheets/")
      env.append_path("#{Dir.pwd}/vendor/assets/javascripts/")
      env.append_path("#{Dir.pwd}/vendor/assets/stylesheets/")
      env.append_path("#{jquery_path}/assets/javascripts/")
      env.append_path("#{Dir.pwd}/tmp/bourbon")
      env.append_path("#{Dir.pwd}/tmp/neat")
      # Defining asset_path fixed the error in the main scss. ¯\_(ツ)_/¯
      env.context_class.class_eval { def asset_path(path, options = {}); end }
    end
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
