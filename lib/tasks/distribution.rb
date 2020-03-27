require "fileutils"
require "sass"

class Distribution
  def initialize
    create_directories
    install_dependencies
    compile_css
  end

  private

  def create_directories
    FileUtils.mkdir_p(Dir.pwd + "/dist/vendor")
    FileUtils.mkdir_p("/tmp/neat")
  end

  def compile_css
    Sass.load_paths << Dir.pwd + "/vendor/assets/stylesheets/" <<
      Dir.pwd + "/tmp/bourbon" <<
      Dir.pwd + "/tmp/neat"
    css_root = Dir.pwd + "/dist/css"
    FileUtils.mkdir_p(css_root)
    Sass.compile_file(Dir.pwd + "/app/assets/stylesheets/cfa_styleguide_main.scss", css_root + "/honeycrisp.css")
  end

  def install_dependencies
    `bourbon install --path tmp && neat install`
    FileUtils.move(Dir.pwd + "/neat", Dir.pwd + "/tmp/neat/")
  end
end
