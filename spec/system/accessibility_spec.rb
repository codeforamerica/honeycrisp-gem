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
FAILING_ACCESSIBILITY_EXAMPLES = [
  "form_builder/v1/cfa_checkbox_set",
  "form_builder/v1/cfa_checkbox_set_with_none",
  "form_builder/v1/cfa_input_field",
  "form_builder/v1/cfa_radio_set_with_follow_up",
  "form_builder/v1/cfa_range_field",
  "form_builder/v1/cfa_select",
  "molecules/incrementer",
  # New issues coming from axe-core-rspec upgrade
  "molecules/progress_step_bar",
  "molecules/show_more",
  "organisms/pagination",
].freeze

RSpec.describe "Accessibility", js: true do
  each_example do |example, example_path|
    describe example do
      it "passes Axe matchers" do
        pending("temporarily ignoring accessibility checks: #{example}") if FAILING_ACCESSIBILITY_EXAMPLES.include?(example)

        visit example_path

        expect(page).to be_axe_clean.skipping(*GENERAL_ACCESSIBILITY_SKIPS).according_to :wcag2a
      end
    end
  end
end
