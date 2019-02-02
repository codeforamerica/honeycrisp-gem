require 'spec_helper'

GENERAL_ACCESSIBILITY_SKIPS = [
  'bypass',
  'document-title',
  'html-has-lang',
  'landmark-one-main',
  'page-has-heading-one',
  'region',
]

SPECIFIC_ACCESSIBILITY_SKIPS = {
  'atoms/form_elements' => [
    'label', # Example demonstrates various input atoms, not label+input molecule
  ],
}

RSpec.describe 'Acessibility', js: true do
  describe 'example' do
    example_files = Dir.glob File.expand_path('../../app/views/examples/**/*.html.erb', __dir__)

    example_files.each do |example_file|
      example_filepath = example_file.match(/app\/views\/examples\/(.*)\.html.erb/)[1]
      example_path = File.dirname(example_filepath) + "/" + File.basename(example_filepath).sub(/^_/, '')

      it "is valid - #{example_path}" do
        visit "/cfa/styleguide/examples/#{example_path}"

        accessibility_skips = GENERAL_ACCESSIBILITY_SKIPS + SPECIFIC_ACCESSIBILITY_SKIPS.fetch(example_path, [])
        expect(page).to be_accessible.skipping(*accessibility_skips)
      end
    end
  end
end