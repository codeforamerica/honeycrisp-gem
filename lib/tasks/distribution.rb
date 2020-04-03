require "fileutils"
require "sprockets_extension/uglifier_source_maps_compressor"

class Distribution
  DIST_PATH = "#{Dir.pwd}/dist".freeze
  SCSS_PATH = "#{DIST_PATH}/scss".freeze
  CSS_PATH = "#{DIST_PATH}/css".freeze
  JS_PATH = "#{DIST_PATH}/js".freeze
  STYLESHEET_PATH = "#{SCSS_PATH}/cfa_styleguide_main.scss".freeze
  ASSET_PATHS = [
    SCSS_PATH,
    "#{Dir.pwd}/app/assets/javascripts/",
    "#{Dir.pwd}/app/assets/stylesheets/",
    "#{Dir.pwd}/vendor/assets/javascripts/",
    "#{Dir.pwd}/vendor/assets/stylesheets/",
    "#{DIST_PATH}/vendor/bourbon",
    "#{DIST_PATH}/vendor/neat",
  ].freeze

  def initialize
    create_directories
    move_assets
    install_dependencies
    compile_css
    compile_js
  end

  private

  def create_directories
    FileUtils.rm_rf(%W(#{DIST_PATH} #{Dir.pwd}.sass-cache #{Dir.pwd}/tmp))
    FileUtils.mkdir_p("#{DIST_PATH}/vendor")
    FileUtils.mkdir_p(CSS_PATH)
    FileUtils.mkdir_p(SCSS_PATH)
  end

  def move_assets
    FileUtils.cp_r("#{Dir.pwd}/app/assets/fonts", DIST_PATH)
    FileUtils.cp_r("#{Dir.pwd}/app/assets/images", DIST_PATH)
    FileUtils.cp_r("#{Dir.pwd}/app/assets/stylesheets/.", SCSS_PATH)
  end

  def compile_css
    sprockets = create_sprockets_env
    assets = sprockets.find_asset(STYLESHEET_PATH)
    assets.write_to("#{CSS_PATH}/honeycrisp.css")

    sprockets = create_sprockets_env(compress: true)
    assets = sprockets.find_asset(STYLESHEET_PATH)
    assets.write_to("#{CSS_PATH}/honeycrisp.min.css")

    `sass --scss --sourcemap=auto \
      -I #{DIST_PATH}/vendor/bourbon \
      -I #{DIST_PATH}/vendor/neat \
      -I #{Dir.pwd}/vendor/assets/stylesheets \
    #{STYLESHEET_PATH} dist/css/honeycrisp.min.css`
  end

  def compile_js
    sprockets = create_sprockets_env
    js_assets = "#{Dir.pwd}/app/assets/javascripts/cfa_styleguide_main.js"
    assets = sprockets.find_asset(js_assets)
    assets.write_to("#{JS_PATH}/honeycrisp.js")

    sprockets = create_sprockets_env(compress: true)
    assets = sprockets.find_asset(js_assets)
    assets.write_to("#{JS_PATH}/honeycrisp.min.js")
  end

  def jquery_path
    $LOAD_PATH.detect { |path| path.match(/jquery-rails(.*)\/vendor/) }
  end

  def create_sprockets_env(compress: false)
    Sprockets::Environment.new do |env|
      env.js_compressor = :uglify_with_source_maps if compress
      env.css_compressor = :sass if compress
      env.append_path("#{jquery_path}/assets/javascripts/") # Can't find the method when inside ASSET_PATHS?
      ASSET_PATHS.each do |path|
        env.append_path(path)
      end
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

  def install_dependencies
    `bourbon install --path dist/vendor && neat install`
    FileUtils.move("#{Dir.pwd}/neat", "#{DIST_PATH}/vendor")

    Sprockets.register_compressor(
      "application/javascript",
        :uglify_with_source_maps,
        UglifierSourceMapsCompressor,
    )
  end
end
