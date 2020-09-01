require "spec_helper"
require "erb"

describe Cfa::Styleguide::CfaV2FormBuilder, type: :view do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
    template.extend ActionView::Helpers::DateHelper
  end

  class FakeModel < Cfa::Styleguide::FormExample; end

  let(:fake_model) do
    FakeModel.new
  end

  let(:form_builder) { Cfa::Styleguide::CfaV2FormBuilder.new("fake_model", fake_model, template, {}) }

  describe ".cfa_button" do
    let(:output) do
      form_builder.cfa_button("my button")
    end

    it "renders a button with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-button")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_button("my button", options: { data: { "disable-with": "Searching..." } })
      end

      it "passes options to the button" do
        html_component = Nokogiri::HTML.fragment(output).at_css(".cfa-button")
        expect(html_component.text).to_not include("Searching...")
      end
    end
  end

  describe ".cfa_text_input" do
    let(:output) do
      form_builder.cfa_text_input(:example_method_with_validation)
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-text-input")
    end

    it "falls back to the defaults used by the Rails form label" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.text).to eq("Example method with validation")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_text_input(:example_method_with_validation, options: {
                                      placeholder: "my text",
                                      disabled: true,
                                    })
      end

      it "passes options to the input" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("disabled")).to be_truthy
        expect(input_html.get_attribute("placeholder")).to eq("my text")
      end
    end

    context "label_text is provided" do
      it "uses the provided label text" do
        output = form_builder.cfa_text_input(:example_method_with_validation, "My method name")

        label = Nokogiri::HTML.fragment(output).at_css("label")
        expect(label.text).to eq("My method name")
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_text_input(:example_method_with_validation, options: {
                                      'aria-describedby': "another-id",
                                    })
      end

      before do
        fake_model.validate
      end

      it "associates form errors with input and appends error id to existing aria-describedby attributes" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(input_html.get_attribute("aria-describedby")).to include("another-id")
        expect(input_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
          wrapper_classes: ["wrapper-class"],
        )
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
          required: true,
        )
      end

      it "does not append the optional text after the label" do
        html_component = Nokogiri::HTML.fragment(output).at_css(".form-question")
        expect(html_component.text).to_not include("(Optional)")
      end

      it "sets the aria-required attribute on the select tag" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("aria-required")).to be_truthy
      end
    end

    context "help text is provided" do
      let(:output) do
        form_builder.cfa_text_input(:example_method_with_validation, help_text: "Found on RAP sheet")
      end

      it "displays the help text" do
        help_text_html = Nokogiri::HTML.fragment(output).at_css(".text--help")
        expect(help_text_html.text).to eq("\n  Found on RAP sheet\n")
      end

      it "associates the help text with the input" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        help_text_html = Nokogiri::HTML.fragment(output).at_css(".text--help")
        help_id = help_text_html.get_attribute("id")
        expect(input_html.get_attribute("aria-describedby")).to include(help_id)
      end
    end
  end

  describe ".cfa_radio" do
    let(:output) do
      form_builder.cfa_radio(:example_method_with_validation, "Truthy value", "true")
    end

    it "renders a radio buttons with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-radio")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_radio(:example_method_with_validation,
                               "Truthy value",
                               "true",
                               options: { 'data-follow-up': "#follow-up-question" })
      end

      it "passes options to the radio button" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("data-follow-up")).to eq("#follow-up-question")
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_radio(:example_method_with_validation,
                               "Truthy value",
                               "true",
                               wrapper_classes: ["wrapper-class"])
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end
  end

  describe ".cfa_radiogroup" do
    let(:output) do
      form_builder.cfa_radiogroup(:example_method_with_validation, "Radio group") do
        ERB.new(
          "<%= form_builder.cfa_radio(:example_method_with_validation, 'First option', :first_option) %>
           <%= form_builder.cfa_radio(:example_method_with_validation, 'Second option', :second_option) %>",
        ).result(binding).html_safe
      end
    end

    it "renders a radio group with valid HTML" do
      expect(output).to be_html_safe
    end

    it "renders all items in passed block" do
      html_component = Nokogiri::HTML.fragment(output).css(".cfa-radio")
      expect(html_component.count).to eq 2
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-radiogroup")
    end

    it "displays a legend" do
      legend = Nokogiri::HTML.fragment(output).at_css("legend")
      expect(legend.text).to include "Radio group"
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_radiogroup(:example_method_with_validation, "Radio group", options: { 'data-option': "some-value" }) do
          ERB.new(
            "<%= form_builder.cfa_radio(:example_method_with_validation, 'First option', :first_option) %>
            <%= form_builder.cfa_radio(:example_method_with_validation, 'Second option', :second_option) %>",
          ).result(binding).html_safe
        end
      end

      it "passes options to the radiogroup" do
        radiogroup_html = Nokogiri::HTML.fragment(output).at_css("radiogroup")
        expect(radiogroup_html.get_attribute("data-option")).to eq("some-value")
      end
    end

    context "errors" do
      before do
        fake_model.validate
      end

      it "should associate form errors with fieldset" do
        fieldset_html = Nokogiri::HTML.fragment(output).at_css("fieldset")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(fieldset_html.get_attribute("aria-describedby")).to eq(error_text_html.get_attribute("id"))
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_radiogroup(:example_method_with_validation, "Radio group", wrapper_classes: ["wrapper-class"]) do
          ERB.new(
            "<%= form_builder.cfa_radio(:example_method_with_validation, 'First option', :first_option) %>
            <%= form_builder.cfa_radio(:example_method_with_validation, 'Second option', :second_option) %>",
          ).result(binding).html_safe
        end
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end
  end

  describe ".cfa_select" do
    let(:select_options) { ["thing one", "thing two"] }

    let(:output) do
      form_builder.cfa_select(:example_method_with_validation, "My select value", select_options)
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-select")
    end

    it "by default appends optional text after the label" do
      html_component = Nokogiri::HTML.fragment(output).at_css(".form-question")
      expect(html_component.text).to include("(Optional)")
    end

    it "includes label with provided text" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.text).to eq("My select value")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_select(
          :example_method_with_validation, "My select value", select_options, options: { include_blank: "Choose an option" }
        )
      end

      it "passes options to the select" do
        first_option_html = Nokogiri::HTML.fragment(output).at_css("option")
        expect(first_option_html.text).to eq("Choose an option")
        expect(first_option_html.get_attribute("value")).to eq("")
      end
    end

    context "when html options provided" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation, "My select value", select_options, html_options: { disabled: true })
      end

      it "passes html_options to the select" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        expect(select_html.get_attribute("disabled")).to be_truthy
      end
    end

    context "errors" do
      before do
        fake_model.validate
      end

      let(:output) do
        form_builder.cfa_select(:example_method_with_validation, "My select value", select_options, html_options: { 'aria-describedby': "another-id" })
      end

      it "should associate form errors with input and append error id to existing aria-describedby attributes" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(select_html.get_attribute("aria-describedby")).to include("another-id")
        expect(select_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation, "My select value", select_options, wrapper_classes: ["wrapper-class"])
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation, "My select value", select_options, required: true)
      end

      it "does not append the optional text after the label" do
        html_component = Nokogiri::HTML.fragment(output).at_css(".form-question")
        expect(html_component.text).to_not include("(Optional)")
      end

      it "sets the aria-required attribute on the select tag" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        expect(select_html.get_attribute("aria-required")).to be_truthy
      end
    end
  end

  describe ".cfa_date_input" do
    let(:output) do
      form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed")
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-date-input")
    end

    it "sets legend inside the fieldset" do
      legend = Nokogiri::HTML.fragment(output).at_css("legend")
      expect(legend.text).to eq("Date case was filed")
    end

    it "uses default help text" do
      month_input = Nokogiri::HTML.fragment(output).at_css(".form-width--month")
      day_input = Nokogiri::HTML.fragment(output).at_css(".form-width--day")
      year_input = Nokogiri::HTML.fragment(output).at_css(".form-width--year")

      expect(month_input.get_attribute("placeholder")).to eq("MM")
      expect(day_input.get_attribute("placeholder")).to eq("DD")
      expect(year_input.get_attribute("placeholder")).to eq("YYYY")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed", options: { class: "some-class" })
      end

      it "passes options to each of the inputs" do
        month_input = Nokogiri::HTML.fragment(output).at_css(".form-width--month")
        day_input = Nokogiri::HTML.fragment(output).at_css(".form-width--day")
        year_input = Nokogiri::HTML.fragment(output).at_css(".form-width--year")
        expect(month_input.classes).to include "some-class"
        expect(day_input.classes).to include "some-class"
        expect(year_input.classes).to include "some-class"
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed", options: { 'aria-describedby': "another-id" })
      end

      before do
        fake_model.validate
      end

      it "associates form errors with each input and appends error id to existing aria-describedby attributes" do
        month_input = Nokogiri::HTML.fragment(output).at_css(".form-width--month")
        day_input = Nokogiri::HTML.fragment(output).at_css(".form-width--day")
        year_input = Nokogiri::HTML.fragment(output).at_css(".form-width--year")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        error_id = error_text_html.get_attribute("id")
        expect(month_input.get_attribute("aria-describedby")).to include(error_id)
        expect(month_input.get_attribute("aria-describedby")).to include("another-id")
        expect(day_input.get_attribute("aria-describedby")).to include(error_id)
        expect(day_input.get_attribute("aria-describedby")).to include("another-id")
        expect(year_input.get_attribute("aria-describedby")).to include(error_id)
        expect(year_input.get_attribute("aria-describedby")).to include("another-id")
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed", wrapper_classes: ["wrapper-class"])
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed", required: true)
      end

      it "sets the aria-required attribute on the select tag" do
        month_input = Nokogiri::HTML.fragment(output).at_css(".form-width--month")
        day_input = Nokogiri::HTML.fragment(output).at_css(".form-width--day")
        year_input = Nokogiri::HTML.fragment(output).at_css(".form-width--year")

        expect(month_input.get_attribute("aria-required")).to be_truthy
        expect(day_input.get_attribute("aria-required")).to be_truthy
        expect(year_input.get_attribute("aria-required")).to be_truthy
      end
    end

    context "help text is provided" do
      let(:output) do
        form_builder.cfa_date_input(:example_method_with_validation, "Date case was filed", help_text: "month/day/year")
      end

      it "splits the help text and displays it in the inputs as placeholder text" do
        month_input = Nokogiri::HTML.fragment(output).at_css(".form-width--month")
        day_input = Nokogiri::HTML.fragment(output).at_css(".form-width--day")
        year_input = Nokogiri::HTML.fragment(output).at_css(".form-width--year")

        expect(month_input.get_attribute("placeholder")).to eq("month")
        expect(day_input.get_attribute("placeholder")).to eq("day")
        expect(year_input.get_attribute("placeholder")).to eq("year")
      end
    end
  end

  describe ".cfa_checkbox" do
    let(:output) { form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff") }

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-checkbox")
    end

    context "options are provided" do
      let(:output) do
        form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff", options: { disabled: true, 'data-some-attribute': "some-value" })
      end

      it "passes options to the checkbox" do
        checkbox_html = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        expect(checkbox_html.get_attribute("disabled")).to be_truthy
        expect(checkbox_html.get_attribute("data-some-attribute")).to eq("some-value")
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff", options: { 'aria-describedby': "another-id" })
      end

      before do
        fake_model.validate
      end

      it "associates form errors with input and appends error id to existing aria-describedby attributes" do
        checkbox_html = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(checkbox_html.get_attribute("aria-describedby")).to include("another-id")
        expect(checkbox_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end
    end

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff", wrapper_classes: ["wrapper-class"])
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end

    context "when disabled" do
      let(:output) do
        form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff", options: { disabled: true })
      end

      it "adds the correct class to the label" do
        label_html = Nokogiri::HTML.fragment(output).at_css("label")
        expect(label_html.classes).to include("is-disabled")
      end
    end

    context "checked and unchecked value" do
      let(:output) do
        form_builder.cfa_checkbox(:example_method_with_validation, "Checkbox stuff", "yes", "no")
      end

      it "uses the values in the generated inputs" do
        hidden_input = Nokogiri::HTML.fragment(output).at_css("input[type='hidden']")
        visible_input = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        expect(hidden_input.get_attribute("value")).to eq "no"
        expect(visible_input.get_attribute("value")).to eq "yes"
      end
    end
  end
end
