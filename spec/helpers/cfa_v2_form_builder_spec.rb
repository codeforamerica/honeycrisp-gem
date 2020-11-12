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

    context "wrapper_classes provided" do
      let(:output) do
        form_builder.cfa_button("my button", wrapper_classes: ["wrapper-class"])
      end

      it "assigns wrapper classes on the containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end
  end

  describe ".cfa_text_input" do
    let(:output) do
      form_builder.cfa_text_input(:example_method_with_validation, "Example method")
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-text-input")
    end

    it "properly constructs a label with optional text" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.text).to include("Example method")
      expect(label.text).to include("(Optional)")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_text_input(:example_method_with_validation,
                                    "Example method with validation",
                                    placeholder: "my text",
                                    disabled: true)
      end

      it "passes options to the input" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("disabled")).to be_truthy
        expect(input_html.get_attribute("placeholder")).to eq("my text")
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_text_input(:example_method_with_validation,
                                    "Example method with validation",
                                    'aria-describedby': "another-id")
      end

      before do
        fake_model.validate
      end

      it "includes text in the label indicating there is an error" do
        label_text = Nokogiri::HTML.fragment(output).at_css("label").text
        expect(label_text).to start_with("Validation error")
      end

      it "associates form errors with input and appends error id to existing aria-describedby attributes" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(input_html.get_attribute("aria-describedby")).to include("another-id")
        expect(input_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end
    end

    context "wrapper_options provided" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
          "Example method with validation",
          wrapper_options: { class: "wrapper-class", id: "wrapper-id" },
        )
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-text-input")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end

    context "label_options provided" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
          "Example method with validation",
          label_options: { class: "label-class", data: { spec: 'label-1' }},
        )
      end

      it "assigns label options on the label" do
        html_component = Nokogiri::HTML.fragment(output).at_css("label")
        expect(html_component.classes).to include("label-class")
        expect(html_component.get_attribute("data-spec")).to include("label-1")
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
          "Example method with validation",
          required: true,
        )
      end

      it "does not append the optional text to the label" do
        label = Nokogiri::HTML.fragment(output).at_css("label")
        expect(label.text).to_not include("(Optional)")
      end

      it "sets the aria-required attribute on the select tag" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("aria-required")).to be_truthy
      end
    end

    context "help text is provided" do
      let(:output) do
        form_builder.cfa_text_input(
          :example_method_with_validation,
            "Example method with validation",
            help_text: "Found on RAP sheet",
        )
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
    let(:output) do
      form_builder.cfa_select(:example_method_with_validation,
                              "My select value",
                              ["thing one", "thing two"])
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-select")
    end

    it "includes label with provided text and optional text" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.text).to include("My select value")
      expect(label.text).to include("(Optional)")
    end

    context "when select_options provided" do
      let(:output) do
        form_builder.cfa_select(
            :example_method_with_validation,
            "My select value",
            ["thing one", "thing two"],
            select_options: { include_blank: "Choose an option" },
            )
      end

      it "passes select_options to the select" do
        options_html = Nokogiri::HTML.fragment(output).at_css("option")
        expect(options_html.text).to eq("Choose an option")
        expect(options_html.get_attribute("value")).to eq("")
      end
    end

    context "select_html_options provided" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation,
                                "My select value",
                                ["thing one", "thing two"],
                                disabled: true,
                                class: "input-class")
      end

      it "passes html_options to the select" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        expect(select_html.get_attribute("disabled")).to be_truthy
        expect(select_html.classes).to include("input-class")
      end

      it "does not overwrite select__element class" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        expect(select_html.classes).to include("select__element")
      end
    end

    context "label_options provided" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation,
                                "My select value",
                                ["thing one", "thing two"],
                                label_options: {
                                    class: "input-class",
                                })
      end

      it "passes label_options to the label" do
        label = Nokogiri::HTML.fragment(output).at_css("label")
        expect(label.classes).to include("input-class")
      end
    end

    context "wrapper_options provided" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation,
                                "My select value",
                                ["thing one", "thing two"],
                                wrapper_options: {
                                    class: "wrapper-class",
                                })
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_select(:example_method_with_validation,
                                "My select value",
                                ["thing one", "thing two"],
                                required: true)
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

    context "errors" do
      before do
        fake_model.validate
      end

      let(:output) do
        form_builder.cfa_select(:example_method_with_validation,
                                "My select value",
                                ["thing one", "thing two"],
                                'aria-describedby': "another-id")
      end

      it "should associate form errors with input and append error id to existing aria-describedby attributes" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(select_html.get_attribute("aria-describedby")).to include("another-id")
        expect(select_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end

      context "with wrapper option classes" do
        let(:output) do
          form_builder.cfa_select(:example_method_with_validation,
                                  "My select value",
                                  ["thing one", "thing two"],
                                  wrapper_options: { class: "foo" })
        end

        it "preserves the form-group--error class" do
          html_component = Nokogiri::HTML.fragment(output).child
          expect(html_component.classes).to include("foo")
          expect(html_component.classes).to include("form-group--error")
        end
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
