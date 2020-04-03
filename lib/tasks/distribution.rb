require "fileutils"
require "sprockets_extension/uglifier_source_maps_compressor"

class Distribution
  def initialize
    create_directories
    move_assets
    install_dependencies
    compile_css
    compile_js
  end

  private

  def create_directories
    FileUtils.rm_rf(%W(#{Dir.pwd}/dist #{Dir.pwd}.sass-cache #{Dir.pwd}/tmp))
    FileUtils.mkdir_p("#{Dir.pwd}/dist/vendor")
    FileUtils.mkdir_p("#{Dir.pwd}/dist/css")
    FileUtils.mkdir_p("#{Dir.pwd}/dist/scss")
  end

  def move_assets
    FileUtils.cp_r("#{Dir.pwd}/app/assets/fonts", "#{Dir.pwd}/dist")
    FileUtils.cp_r("#{Dir.pwd}/app/assets/images", "#{Dir.pwd}/dist")
    FileUtils.cp_r("#{Dir.pwd}/app/assets/stylesheets/.", "#{Dir.pwd}/dist/scss")
  end

  def compile_css
    css_root = "#{Dir.pwd}/dist/css"

    sprockets = create_sprockets_env
    assets = sprockets.find_asset("#{Dir.pwd}/dist/scss/cfa_styleguide_main.scss")
    assets.write_to("#{css_root}/honeycrisp.css")

    sprockets = create_sprockets_env(compress: true)
    assets = sprockets.find_asset("#{Dir.pwd}/dist/scss/cfa_styleguide_main.scss")
    assets.write_to("#{css_root}/honeycrisp.min.css")

    `sass --scss --sourcemap=auto \
      -I #{Dir.pwd}/dist/vendor/bourbon \
      -I #{Dir.pwd}/dist/vendor/neat \
      -I #{Dir.pwd}/vendor/assets/stylesheets \
      #{Dir.pwd}/dist/scss/cfa_styleguide_main.scss dist/css/honeycrisp.min.css`
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
      env.append_path("#{Dir.pwd}/dist/scss")
      env.append_path("#{Dir.pwd}/app/assets/javascripts/")
      env.append_path("#{Dir.pwd}/app/assets/stylesheets/")
      env.append_path("#{Dir.pwd}/vendor/assets/javascripts/")
      env.append_path("#{Dir.pwd}/vendor/assets/stylesheets/")
      env.append_path("#{jquery_path}/assets/javascripts/")
      env.append_path("#{Dir.pwd}/dist/vendor/bourbon")
      env.append_path("#{Dir.pwd}/dist/vendor/neat")
      env.context_class.class_eval do
        def asset_path(path, options = {})
          case options[:type]
          when :image
            "/dist/images/#{path}"
          when :font
            "/dist/fonts/#{path}"
          end
        end
      end
    end
  end
end

def install_dependencies
  `bourbon install --path dist/vendor && neat install`
  FileUtils.move("#{Dir.pwd}/neat", "#{Dir.pwd}/dist/vendor")

  Sprockets.register_compressor(
    "application/javascript",
      :uglify_with_source_maps,
      UglifierSourceMapsCompressor,
  )
end
