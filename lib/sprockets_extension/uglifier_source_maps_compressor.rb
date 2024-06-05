require "sprockets/digest_utils"
require "sprockets/uglifier_compressor"
require "json"
require "fileutils"

class UglifierSourceMapsCompressor < Sprockets::UglifierCompressor
  def initialize
    super
    @uglifier = Sprockets::Autoload::Uglifier.new
  end

  def call(input)
    data = input.fetch(:data)
    name = input.fetch(:name)

    compressed_data, sourcemap_json = @uglifier.compile_with_map(data)

    sourcemap = prepare_sourcemap(sourcemap_json, name, data)
    sourcemap_json = sourcemap.to_json

    sourcemap_filename = "honeycrisp.min.js.map"
    sourcemap_path = File.join(Dir.pwd, 'dist', 'js', sourcemap_filename)

    write_sourcemap(sourcemap_path, sourcemap_json)

    compressed_data.concat "\n//# sourceMappingURL=#{sourcemap_filename}\n"
  end

  private

  def prepare_sourcemap(sourcemap_json, name, data)
    sourcemap = JSON.parse(sourcemap_json)
    sourcemap["sources"] = ["#{name}.js"]
    sourcemap["sourceRoot"] = Dir.pwd
    sourcemap["sourcesContent"] = [data]
    sourcemap
  end

  def write_sourcemap(path, content)
    FileUtils.mkdir_p File.dirname(path)
    File.write(path, content)
  rescue IOError => e
    raise "Failed to write sourcemap: #{e.message}"
  end

  def digest(io)
    Sprockets::DigestUtils.pack_hexdigest Sprockets::DigestUtils.digest(io)
  end
end
