require "fileutils"
require "sassc"
require "sprockets_extension/uglifier_source_maps_compressor"
require "autoprefixer-rails"

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
    FileUtils.mkdir_p(JS_PATH)
  end

  def move_assets
    FileUtils.cp_r("#{Dir.pwd}/app/assets/fonts", DIST_PATH)
    FileUtils.cp_r("#{Dir.pwd}/app/assets/images", DIST_PATH)
    FileUtils.cp_r("#{Dir.pwd}/app/assets/stylesheets/.", SCSS_PATH)
  end

  def compile_css
    scss_file = File.read("#{Dir.pwd}/app/assets/stylesheets/cfa_styleguide_main.scss")

    load_paths = [
      "#{Dir.pwd}/app/assets/stylesheets/",
      "#{Dir.pwd}/vendor/assets/stylesheets/",
      "#{DIST_PATH}/vendor/bourbon",
      "#{DIST_PATH}/vendor/neat",
    ]

    compile_css_with_sourcemaps(scss_file, "honeycrisp.css", load_paths)
    compile_css_with_sourcemaps(scss_file, "honeycrisp.min.css", load_paths, compressed: true)
  end

  def compile_js
    sprockets = create_sprockets_env
    assets = "#{Dir.pwd}/app/assets/javascripts/cfa_styleguide_main.js"
    js_assets = sprockets.find_asset(assets)
    js = js_assets.to_s
    add_version_comment(js)
    File.write("#{JS_PATH}/honeycrisp.js", js)

    sprockets = create_sprockets_env(compress: true)
    min_js_assets = sprockets.find_asset(assets)
    min_js = min_js_assets.to_s
    add_version_comment(min_js)
    File.write("#{JS_PATH}/honeycrisp.min.js", min_js)
  end

  def add_version_comment(file)
    file["Honeycrisp version placeholder"] = "Honeycrisp v#{Cfa::Styleguide::VERSION} built on #{Date.today}"
  end

  def jquery_path
    $LOAD_PATH.detect { |path| path.match(/jquery-rails(.*)\/vendor/) }
  end

  def create_sprockets_env(compress: false)
    Sprockets::Environment.new do |env|
      env.js_compressor = :uglify_with_source_maps if compress
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
    `bourbon install --path dist/vendor`

    Sprockets.register_compressor(
      "application/javascript",
      :uglify_with_source_maps,
      UglifierSourceMapsCompressor,
    )
  end

  def compile_css_with_sourcemaps(scss_file, css_filename, load_paths, compressed: false)
    options = { filename: css_filename,
                output_path: "#{CSS_PATH}/#{css_filename}",
                source_map_file: "#{CSS_PATH}/#{css_filename}.map",
                load_paths: load_paths }

    options[:style] = :compressed if compressed

    engine = SassC::Engine.new(scss_file, options)
    css = AutoprefixerRails.process(engine.render).css
    add_version_comment(css)
    File.write("#{CSS_PATH}/#{css_filename}", css)

    map = engine.source_map
    File.write("#{CSS_PATH}/#{css_filename}.map", map)
  end
end
