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

## Examples with accessibility issues that must be fixed in the fullness of time
FIXABLE_ACCESSIBILITY_EXAMPLES = [
  "form_builder/cfa_checkbox_set",
  "form_builder/cfa_checkbox_set_with_none",
  "form_builder/cfa_date_select",
  "form_builder/cfa_input_field",
  "form_builder/cfa_radio_set",
  "form_builder/cfa_radio_set_with_follow_up",
  "form_builder/cfa_range_field",
  "form_builder/cfa_select",
  "form_builder/cfa_textarea",
  "molecules/follow_up_question",
  "molecules/form_group",
  "molecules/form_group_error_state",
  "molecules/incrementer",
  "molecules/inline_input_group",
  "molecules/searchbar",
  "molecules/text_input_group",
  "molecules/two_up_input_group",
].freeze

RSpec.describe "Acessibility", js: true do
  each_example do |example, example_path|
    describe example do
      it "passes Axe matchers" do
        pending("temporarily ignoring accessibility checks") if FIXABLE_ACCESSIBILITY_EXAMPLES.include?(example)

        visit example_path

        expect(page).to be_accessible.skipping(*GENERAL_ACCESSIBILITY_SKIPS)
      end
    end
  end
end
