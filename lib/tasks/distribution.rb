require "fileutils"
require "sass"

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
    assets = sprockets.find_asset(Dir.pwd + "/app/assets/javascripts/cfa_styleguide_main.js")
    assets.write_to(Dir.pwd + "/dist/js/honeycrisp.js")
  end

  def jquery_path
    $LOAD_PATH.detect do |path|
      path.match(/jquery-rails(.*)\/vendor/)
    end
  end

  def create_sprockets_env
    sprockets = Sprockets::Environment.new
    sprockets.append_path("#{Dir.pwd}/app/assets/javascripts/")
    sprockets.append_path("#{Dir.pwd}/vendor/assets/javascripts/")
    sprockets.append_path("#{jquery_path}/assets/javascripts/")
    sprockets
  end

  def install_dependencies
    `bourbon install --path tmp && neat install`
    FileUtils.move(Dir.pwd + "/neat", Dir.pwd + "/tmp/neat/")
  end
end
