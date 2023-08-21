require "sprockets/digest_utils"
require "sprockets/uglifier_compressor"

class UglifierSourceMapsCompressor < Sprockets::UglifierCompressor
  def call(input)
    data = input.fetch(:data)
    name = input.fetch(:name)

    uglifier ||= Sprockets::Autoload::Uglifier.new
    compressed_data, sourcemap_json = uglifier.compile_with_map(input[:data])

    sourcemap = JSON.parse(sourcemap_json)
    sourcemap["sources"] = ["#{name}.js"]
    sourcemap["sourceRoot"] = Dir.pwd
    sourcemap["sourcesContent"] = [data]
    sourcemap_json = sourcemap.to_json

    sourcemap_filename = "honeycrisp.min.js.map"
    sourcemap_path = "#{Dir.pwd}/dist/js/#{sourcemap_filename}"
    sourcemap_url = sourcemap_filename

    FileUtils.mkdir_p File.dirname(sourcemap_path)
    File.write(sourcemap_path, sourcemap_json)

    compressed_data.concat "\n//# sourceMappingURL=#{sourcemap_url}\n"
  end

  def digest(io)
    Sprockets::DigestUtils.pack_hexdigest Sprockets::DigestUtils.digest(io)
  end
end
