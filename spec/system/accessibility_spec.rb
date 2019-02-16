require "spec_helper"

## Checks that aren't applicable to non-whole-page examples
GENERAL_ACCESSIBILITY_SKIPS = [
  "bypass",
  "document-title",
  "html-has-lang",
  "landmark-one-main",
  "page-has-heading-one",
  "region",
].freeze

## Checks that aren't applicable to specific examples and can be ignored
SPECIFIC_ACCESSIBILITY_SKIPS = {
  "atoms/form_elements" => [
    "label", # Example demonstrates various input atoms, not label+input molecule
  ],
}.freeze

## Examples with accessibility issues that must be fixed in the fullness of time
FIXABLE_ACCESSIBILITY_EXAMPLES = [
  "atoms/labels",
  "atoms/typography",
  "form_builder/cfa_checkbox_set",
  "form_builder/cfa_checkbox_set_with_none",
  "form_builder/cfa_date_select",
  "form_builder/cfa_input_field",
  "form_builder/cfa_radio_set",
  "form_builder/cfa_radio_set_with_follow_up",
  "form_builder/cfa_range_field",
  "form_builder/cfa_select",
  "form_builder/cfa_textarea",
  "molecules/block_input_group",
  "molecules/flash_messages",
  "molecules/follow_up_question",
  "molecules/form_group",
  "molecules/form_group_error_state",
  "molecules/incrementer",
  "molecules/inline_input_group",
  "molecules/searchbar",
  "molecules/text_input_group",
  "molecules/toolbar",
  "molecules/two_up_input_group",
  "organisms/pagination",
].freeze

RSpec.describe "Acessibility", js: true do
  describe "example" do
    example_files = Dir.glob File.expand_path("../../app/views/examples/**/*.html.erb", __dir__)

    example_files.each do |example_file|
      example_filepath = example_file.match(/app\/views\/examples\/(.*)\.html.erb/)[1]
      example_path = File.dirname(example_filepath) + "/" + File.basename(example_filepath).sub(/^_/, "")

      it "is valid - #{example_path}" do
        pending("temporarily ignoring accessibility checks") if FIXABLE_ACCESSIBILITY_EXAMPLES.include?(example_path)

        visit "/cfa/styleguide/examples/#{example_path}"

        accessibility_skips = GENERAL_ACCESSIBILITY_SKIPS + SPECIFIC_ACCESSIBILITY_SKIPS.fetch(example_path, [])
        expect(page).to be_accessible.skipping(*accessibility_skips)
      end
    end
  end
end
