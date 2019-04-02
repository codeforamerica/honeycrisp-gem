module ExamplesHelper
  def each_example
    example_files = Dir.glob File.expand_path("../../app/views/examples/**/*.html.erb", __dir__)

    example_files.each do |example_file|
      example_filepath = example_file.match(/app\/views\/examples\/(.*)\.html.erb/)[1]
      example_path = File.dirname(example_filepath) + "/" + File.basename(example_filepath).sub(/^_/, "")
      example_viewpath = "/cfa/styleguide/examples/#{example_path}"

      yield(example_path, example_viewpath, example_file)
    end
  end
end

RSpec.configure do |config|
  config.extend ExamplesHelper, type: :system
end
