require 'spec_helper'

RSpec.describe 'Acessibility', js: true do
  describe 'examples' do
    example_files = Dir.glob File.expand_path('../../app/views/examples/**/*.html.erb', __dir__)

    example_files.each do |example_file|
      example_filepath = example_file.match(/app\/views\/(.*)\.html.erb/)[1]
      example_path = File.dirname(example_filepath) + "/" + File.basename(example_filepath).sub(/^_/, '')

      it "is valid - #{example_path}" do
        # Capybara.server = :webrick
        # driven_by :selenium, using: :headless_chrome
        visit "/cfa/styleguide/#{example_path}"
        expect(page).to be_accessible.skipping(
          'document-title',
          'html-has-lang',
          'landmark-one-main',
          'page-has-heading-one',
          'region'
        )
      end
    end
  end
end