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
        form_builder.cfa_button("my button", data: { "disable-with": "Searching..." })
      end

      it "passes options to the button" do
        html_component = Nokogiri::HTML.fragment(output).at_css(".cfa-button")
        expect(html_component.text).to_not include("Searching...")
      end
    end

    context "wrapper_options provided" do
      let(:output) do
        form_builder.cfa_button("my button", wrapper_options: { class: "wrapper-class", id: "wrapper-id" })
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-button")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end
  end

  describe ".cfa_text_field" do
    let(:output) do
      form_builder.cfa_text_field(:example_method_with_validation, "Example method")
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-text-field")
      expect(html_component.classes).to include("form-group")
    end

    it "properly constructs a label with optional text" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.classes).to include("form-question")
      expect(label.text).to include("Example method")
      expect(label.text).to include("(Optional)")
    end

    it "sets default options on the input" do
      input_html = Nokogiri::HTML.fragment(output).at_css("input")
      expect(input_html.get_attribute("autocomplete")).to eq("off")
      expect(input_html.get_attribute("autocorrect")).to eq("off")
      expect(input_html.get_attribute("autocapitalize")).to eq("off")
      expect(input_html.get_attribute("spellcheck")).to eq("false")
    end

    context "when options provided" do
      let(:output) do
        form_builder.cfa_text_field(:example_method_with_validation,
          "Example method with validation",
          class: "foo",
          placeholder: "my text",
          disabled: true,
          autocomplete: true)
      end

      it "passes options to the input" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("disabled")).to be_truthy
        expect(input_html.get_attribute("autocomplete")).to be_truthy
        expect(input_html.get_attribute("placeholder")).to eq("my text")
      end

      it "does not override text-input class" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.classes).to include("foo")
        expect(input_html.classes).to include("text-input")
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_text_field(:example_method_with_validation,
          "Example method with validation",
          "aria-describedby": "another-id")
      end

      before do
        fake_model.validate
      end

      it "includes text in the label indicating there is an error" do
        label_text = Nokogiri::HTML.fragment(output).at_css("label").text
        expect(label_text).to start_with("Validation error")
      end

      it "adds an error class to containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("form-group--error")
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
        form_builder.cfa_text_field(
          :example_method_with_validation,
          "Example method with validation",
          wrapper_options: { class: "wrapper-class", id: "wrapper-id" },
        )
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-text-field")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end

    context "label_options provided" do
      let(:output) do
        form_builder.cfa_text_field(
          :example_method_with_validation,
          "Example method with validation",
          label_options: { class: "label-class", data: { spec: "label-1" } },
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
        form_builder.cfa_text_field(
          :example_method_with_validation,
          "Example method with validation",
          required: true,
        )
      end

      it "does not append the optional text to the label" do
        label = Nokogiri::HTML.fragment(output).at_css("label")
        expect(label.text).to_not include("(Optional)")
      end

      it "sets the required attribute on the select tag" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("required")).to be_truthy
      end
    end

    context "help text is provided" do
      let(:output) do
        form_builder.cfa_text_field(
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
      expect(html_component.classes).to include("form-group")
    end

    it "includes label with provided text and optional text" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.classes).to include("form-question")
      expect(label.text).to include("My select value")
      expect(label.text).to include("(Optional)")
    end

    it "sets select-related classes" do
      select_html = Nokogiri::HTML.fragment(output).at_css("select")
      expect(select_html.classes).to include("select__element")
      expect(select_html.parent.classes).to include("select")
    end

    it "sets default options on the input" do
      select_html = Nokogiri::HTML.fragment(output).at_css("select")
      expect(select_html.get_attribute("autocomplete")).to eq("off")
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
        html_component = Nokogiri::HTML.fragment(output).at_css("label")
        expect(html_component.text).to_not include("(Optional)")
      end

      it "sets the required attribute on the select tag" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        expect(select_html.get_attribute("required")).to be_truthy
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
          "aria-describedby": "another-id")
      end

      it "should associate form errors with input and append error id to existing aria-describedby attributes" do
        select_html = Nokogiri::HTML.fragment(output).at_css("select")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(select_html.get_attribute("aria-describedby")).to include("another-id")
        expect(select_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end

      it "adds an error class to containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("form-group--error")
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

  describe ".cfa_fieldset" do
    let(:output) do
      form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons") do
        ERB.new(
          "<%= form_builder.cfa_radio_button(:example_method_with_validation, 'First option', :first_option) %>
         <%= form_builder.cfa_radio_button(:example_method_with_validation, 'Second option', :second_option) %>",
        ).result(binding).html_safe
      end
    end

    it "renders a fieldset with valid HTML" do
      expect(output).to be_html_safe
    end

    it "renders all items in passed block" do
      html_component = Nokogiri::HTML.fragment(output).css(".cfa-radio-button")
      expect(html_component.count).to eq 2
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-fieldset")
      expect(html_component.classes).to include("form-group")
    end

    it "displays a legend" do
      legend = Nokogiri::HTML.fragment(output).at_css("legend")
      expect(legend.text).to include "My radio buttons"
      expect(legend.classes).to include("form-question")
    end

    context "wrapper_options provided" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons", wrapper_options: { id: "wrapper-id", class: "wrapper-class" }) do
          ERB.new(
            "<%= form_builder.cfa_radio_button(:example_method_with_validation, 'First option', :first_option) %>
          <%= form_builder.cfa_radio_button(:example_method_with_validation, 'Second option', :second_option) %>",
          ).result(binding).html_safe
        end
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-fieldset")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end

    context "when fieldset_html_options provided" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons", class: "my-class", id: "my-id") do
          ERB.new(
            "<%= form_builder.cfa_radio_button(:example_method_with_validation, 'First option', :first_option) %>
          <%= form_builder.cfa_radio_button(:example_method_with_validation, 'Second option', :second_option) %>",
          ).result(binding).html_safe
        end
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).at_css("fieldset")
        expect(html_component.classes).to include("my-class")
        expect(html_component.get_attribute("id")).to include("my-id")
      end
    end

    context "label_options provided" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons", label_options: { class: "label-class", data: { spec: "label-1" } })
      end

      it "assigns label options on the legend" do
        html_component = Nokogiri::HTML.fragment(output).at_css("legend")
        expect(html_component.classes).to include("label-class")
        expect(html_component.get_attribute("data-spec")).to include("label-1")
      end
    end

    context "when no block given" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons")
      end

      it "does not raise an error" do
        expect(output).to be_html_safe
      end
    end

    context "errors" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons", label_options: { "aria-describedby": "another-id" })
      end

      before do
        fake_model.validate
      end

      it "includes text for screen readers in the legend indicating there is an error" do
        label_text = Nokogiri::HTML.fragment(output).css("legend .sr-only").map(&:text).join(" ")
        expect(label_text).to start_with("Validation error")
      end

      it "adds an error class to containing element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("form-group--error")
      end

      it "associates form errors with legend and appends error id to existing aria-describedby attributes" do
        # Note: we're not sure if associating the errors to the legend is the best approach,
        # but wasn't sure how best to do it since we don't have inputs in this block
        legend_html = Nokogiri::HTML.fragment(output).at_css("legend")
        error_text_html = Nokogiri::HTML.fragment(output).at_css(".text--error")
        expect(legend_html.get_attribute("aria-describedby")).to include("another-id")
        expect(legend_html.get_attribute("aria-describedby")).to include(error_text_html.get_attribute("id"))
      end
    end

    context "required is true" do
      let(:output) do
        form_builder.cfa_fieldset(:example_method_with_validation, "My radio buttons", required: true)
      end

      it "does not append the optional sr-only text after the legend" do
        # This is another place where it's an awkward fit. I think we want to show "optional" visually
        # and with screenreaders here with the legend, but "required" as an attribute can only be
        # set on inputs, not fieldsets or legends.

        html_component = Nokogiri::HTML.fragment(output).at_css("legend")
        expect(html_component.text).to_not include("(Optional)")
      end
    end
  end

  describe ".cfa_radio" do
    let(:output) do
      form_builder.cfa_radio_button(:example_method_with_validation, "Truthy value", "true")
    end

    it "renders a radio buttons with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-radio-button")
    end

    it "includes identifying class on the label of radio button" do
      label = Nokogiri::HTML.fragment(output).at_css("label")
      expect(label.classes).to include("radio-button")
    end

    context "when input options provided" do
      let(:output) do
        form_builder.cfa_radio_button(:example_method_with_validation,
          "Truthy value",
          "true",
          "data-follow-up": "#follow-up-question")
      end

      it "passes options to the radio button" do
        input_html = Nokogiri::HTML.fragment(output).at_css("input")
        expect(input_html.get_attribute("data-follow-up")).to eq("#follow-up-question")
      end
    end

    context "wrapper options provided" do
      let(:output) do
        form_builder.cfa_radio_button(:example_method_with_validation,
          "Truthy value",
          "true",
          wrapper_options: { class: "wrapper-class", id: "wrapper-id" })
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-radio-button")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end
  end

  describe ".cfa_check_box" do
    let(:output) { form_builder.cfa_check_box(:example_method_with_validation, "Checkbox stuff") }

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-check-box")
    end

    it "includes an identifying class on the label" do
      checkbox = Nokogiri::HTML.fragment(output).at_css("label")
      expect(checkbox.classes).to include("checkbox")
    end

    it "includes a hook class around the label text" do
      label = Nokogiri::HTML.fragment(output).at_css(".checkbox__label")
      expect(label.text).to include("Checkbox stuff")
    end

    context "input options provided" do
      let(:output) do
        form_builder.cfa_check_box(:example_method_with_validation, "Checkbox stuff", disabled: true, "data-some-attribute": "some-value")
      end

      it "passes input options to the checkbox" do
        checkbox_html = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        expect(checkbox_html.get_attribute("disabled")).to be_truthy
        expect(checkbox_html.get_attribute("data-some-attribute")).to eq("some-value")
      end
    end

    context "wrapper options provided" do
      let(:output) do
        form_builder.cfa_check_box(:example_method_with_validation,
          "Checkbox stuff",
          wrapper_options: {
            class: "wrapper-class",
            id: "wrapper-id",
          })
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-check-box")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end

    context "checked and unchecked value" do
      let(:output) do
        form_builder.cfa_check_box(:example_method_with_validation, "Checkbox stuff", "yes", "no")
      end

      it "uses the values in the generated inputs" do
        hidden_input = Nokogiri::HTML.fragment(output).at_css("input[type='hidden']")
        visible_input = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        expect(hidden_input.get_attribute("value")).to eq "no"
        expect(visible_input.get_attribute("value")).to eq "yes"
      end
    end
  end

  describe ".cfa_collection_check_boxes" do
    let(:output) do
      form_builder.cfa_collection_check_boxes(:example_method_with_validation,
        [
          Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
          Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
        ],
        :id,
        :name)
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-collection-check-boxes")
    end

    it "includes an identifying class on the label" do
      checkboxes = Nokogiri::HTML.fragment(output).at_css("label")
      expect(checkboxes.classes).to include("checkbox")
    end

    it "includes a hook class around the label text" do
      labels = Nokogiri::HTML.fragment(output).css(".checkbox__label")
      expect(labels.map(&:text)).to match_array(["One", "Two"])
    end

    context "input options provided" do
      let(:output) do
        form_builder.cfa_collection_check_boxes(:example_method_with_validation,
          [
            Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
            Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
          ],
          :id,
          :name,
          disabled: true,
          "data-some-attribute": "some-value")
      end

      it "passes input options to the checkboxes" do
        checkbox_html = Nokogiri::HTML.fragment(output).at_css("input[type='checkbox']")
        expect(checkbox_html.get_attribute("disabled")).to be_truthy
        expect(checkbox_html.get_attribute("data-some-attribute")).to eq("some-value")
      end
    end

    context "wrapper options provided" do
      let(:output) do
        form_builder.cfa_collection_check_boxes(:example_method_with_validation,
          [
            Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
            Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
          ],
          :id,
          :name,
          wrapper_options: {
            class: "wrapper-class",
            id: "wrapper-id",
          })
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-collection-check-boxes")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end
  end

  describe ".cfa_collection_radio_buttons" do
    let(:output) do
      form_builder.cfa_collection_radio_buttons(:example_method_with_validation,
        [
          Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
          Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
        ],
        :id,
        :name)
    end

    it "renders a text input with valid HTML" do
      expect(output).to be_html_safe
    end

    it "includes an identifying class on the containing element" do
      html_component = Nokogiri::HTML.fragment(output).child
      expect(html_component.classes).to include("cfa-collection-radio-buttons")
    end

    it "includes identifying class on the label of radio button" do
      labels = Nokogiri::HTML.fragment(output).at_css("label")
      expect(labels.classes).to include("radio-button")
    end

    context "input options provided" do
      let(:output) do
        form_builder.cfa_collection_radio_buttons(:example_method_with_validation,
          [
            Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
            Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
          ],
          :id,
          :name,
          disabled: true,
          "data-some-attribute": "some-value")
      end

      it "passes input options to the checkboxes" do
        checkbox_html = Nokogiri::HTML.fragment(output).at_css("input[type='radio']")
        expect(checkbox_html.get_attribute("disabled")).to be_truthy
        expect(checkbox_html.get_attribute("data-some-attribute")).to eq("some-value")
      end
    end

    context "wrapper options provided" do
      let(:output) do
        form_builder.cfa_collection_radio_buttons(:example_method_with_validation,
          [
            Cfa::Styleguide::FormExample.new(id: 1, name: "One"),
            Cfa::Styleguide::FormExample.new(id: 2, name: "Two"),
          ],
          :id,
          :name,
          wrapper_options: {
            class: "wrapper-class",
            id: "wrapper-id",
          })
      end

      it "does not overwrite existing classes" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("cfa-collection-radio-buttons")
      end

      it "assigns wrapper options on the outermost element" do
        html_component = Nokogiri::HTML.fragment(output).child
        expect(html_component.classes).to include("wrapper-class")
        expect(html_component.get_attribute("id")).to include("wrapper-id")
      end
    end
  end
end
