require "spec_helper"

RSpec.describe Cfa::Styleguide::CfaFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::DateHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
  end

  describe "#cfa_checkbox" do
    it "renders an accessible checkbox input" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :read_tos

        validates_presence_of :read_tos
      end

      sample = SampleForm.new
      sample.validate
      form = described_class.new("sample", sample, template, {})
      output = form.cfa_checkbox(
        :read_tos,
        "Confirm that you agree to Terms of Service",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
      <fieldset class="input-group form-group form-group--error">
        <label class="checkbox">
          <input name="sample[read_tos]" type="hidden" value="0" autocomplete="off" />
          <div class="field_with_errors">
            <input aria-describedby="sample_read_tos__errors" type="checkbox" value="1" name="sample[read_tos]" id="sample_read_tos"/>
          </div>
          Confirm that you agree to Terms of Service
        </label>
        <span class="text--error" id="sample_read_tos__errors">
          <i class="icon-warning"></i> can't be blank
        </span>
      </fieldset>
      HTML
    end

    context "when checkbox value is equal to checked value" do
      it "renders checkbox as selected" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :read_tos
        end

        sample = SampleForm.new(read_tos: "yes")
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox(:read_tos,
          "Confirm that you agree to Terms of Service",
          options: {
            checked_value: "yes",
            unchecked_value: "no",
          })

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group">
          <label class="checkbox">
            <input name="sample[read_tos]" type="hidden" value="no" autocomplete="off" />
            <input checked_value="yes" unchecked_value="no" type="checkbox" value="yes" checked="checked" name="sample[read_tos]" id="sample_read_tos" />
            Confirm that you agree to Terms of Service
          </label>
        </fieldset>
        HTML
      end
    end

    context "when checkbox is disabled and value is equal to checked value" do
      it "renders disabled checkbox as selected" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :read_tos
        end

        sample = SampleForm.new(read_tos: "yes")
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox(:read_tos,
          "Confirm that you agree to Terms of Service",
          options: {
            checked_value: "yes",
            unchecked_value: "no",
            disabled: true,
          })

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group">
          <label class="checkbox is-selected is-disabled">
            <input name="sample[read_tos]" disabled="disabled" type="hidden" value="no" autocomplete="off" />
            <input checked_value="yes" unchecked_value="no" disabled="disabled" type="checkbox" value="yes" checked="checked" name="sample[read_tos]" id="sample_read_tos" />
            Confirm that you agree to Terms of Service
          </label>
        </fieldset>
        HTML
      end
    end
  end

  describe "#cfa_checkbox_set" do
    context "with validation error" do
      it "renders an accessible set of checkbox inputs" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :tng, :ds9, :voyager, :tos

          validate :custom_validation

          def custom_validation
            errors.add(:captains, "Pick a captain.")
          end
        end

        sample = SampleForm.new
        sample.validate
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox_set(
          :captains,
          [
            { method: :tng, label: "Picard" },
            { method: :ds9, label: "Sisko" },
            { method: :voyager, label: "Janeway" },
            { method: :tos, label: "Kirk" },
          ],
          label_text: "Which captains do you think are cool?",
          help_text: "like, really cool",
        )

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group form-group--error" aria-describedby="sample_captains__help-text sample_captains__errors">
          <legend class="form-question "> Which captains do you think are cool? </legend>
          <p class="text--help" id="sample_captains__help-text">like, really cool</p>
          <label class="checkbox"><input name="sample[tng]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tng]" id="sample_tng"/> Picard </label>
          <label class="checkbox"><input name="sample[ds9]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[ds9]" id="sample_ds9"/> Sisko </label>
          <label class="checkbox"><input name="sample[voyager]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[voyager]" id="sample_voyager"/> Janeway </label>
          <label class="checkbox"><input name="sample[tos]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tos]" id="sample_tos"/> Kirk </label>
          <span class="text--error" id="sample_captains__errors"><i class="icon-warning"></i> Pick a captain. </span>
        </fieldset>
        HTML
      end
    end

    it "renders an accessible set of checkbox inputs" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :tng, :ds9, :voyager, :tos
      end

      sample = SampleForm.new
      form = described_class.new("sample", sample, template, {})
      output = form.cfa_checkbox_set(
        :captains,
        [
          { method: :tng, label: "Picard" },
          { method: :ds9, label: "Sisko" },
          { method: :voyager, label: "Janeway" },
          { method: :tos, label: "Kirk" },
        ],
        label_text: "Which captains do you think are cool?",
        help_text: "like, really cool",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group" aria-describedby="sample_captains__help-text">
          <legend class="form-question "> Which captains do you think are cool? </legend>
          <p class="text--help" id="sample_captains__help-text">like, really cool</p>
          <label class="checkbox"><input name="sample[tng]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tng]" id="sample_tng"/> Picard </label>
          <label class="checkbox"><input name="sample[ds9]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[ds9]" id="sample_ds9"/> Sisko </label>
          <label class="checkbox"><input name="sample[voyager]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[voyager]" id="sample_voyager"/> Janeway </label>
          <label class="checkbox"><input name="sample[tos]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tos]" id="sample_tos"/> Kirk </label>
        </fieldset>
      HTML
    end
  end

  describe "#cfa_checkbox_set_with_none" do
    context "with validation error" do
      it "renders an accessible set of checkbox inputs" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :tng, :ds9, :voyager, :tos, :none

          validate :custom_validation

          def custom_validation
            errors.add(:captains, "Pick a captain.")
          end
        end

        sample = SampleForm.new
        sample.validate
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox_set_with_none(
          :captains,
          [
            { method: :tng, label: "Picard" },
            { method: :ds9, label: "Sisko" },
            { method: :voyager, label: "Janeway" },
            { method: :tos, label: "Kirk" },
          ],
          label_text: "Which captains do you think are cool?",
        )

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group form-group--error checkbox-none">
          <legend class="sr-only"> Which captains do you think are cool? </legend>
          <label class="checkbox"><input name="sample[tng]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tng]" id="sample_tng"/> Picard </label>
          <label class="checkbox"><input name="sample[ds9]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[ds9]" id="sample_ds9"/> Sisko </label>
          <label class="checkbox"><input name="sample[voyager]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[voyager]" id="sample_voyager"/> Janeway </label>
          <label class="checkbox"><input name="sample[tos]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[tos]" id="sample_tos"/> Kirk </label>
          <hr />
          <label class="checkbox"><input name="sample[none]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[none]" id="sample_none" /> None of the above </label>
          <span class="text--error" id="sample_captains__errors"><i class="icon-warning"></i> Pick a captain. </span>
        </fieldset>
        HTML
      end
    end

    it "renders an accessible set of checkbox inputs" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :first, :second, :none
      end

      sample = SampleForm.new(first: "1", second: "0")
      form = described_class.new("sample", sample, template, {})
      output = form.cfa_checkbox_set_with_none(
        :set_method_name,
        [
          { method: :first, label: "First value" },
          { method: :second, label: "Second value" },
        ],
        label_text: "What values does this member have?",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group checkbox-none">
          <legend class="sr-only"> What values does this member have? </legend>
          <label class="checkbox"><input name="sample[first]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[first]" id="sample_first" /> First value </label>
          <label class="checkbox"><input name="sample[second]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[second]" id="sample_second" /> Second value </label>
          <hr />
          <label class="checkbox"><input name="sample[none]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[none]" id="sample_none"/> None of the above </label>
        </fieldset>
      HTML
    end

    context "when enum is true" do
      it "sets checked value to yes and unchecked value to no" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :first, :second, :none
        end

        sample = SampleForm.new(first: "yes", second: "no")
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox_set_with_none(
          :set_method_name,
          [
            { method: :first, label: "First value" },
            { method: :second, label: "Second value" },
          ],
          label_text: "What values does this member have?",
          enum: true,
        )

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group checkbox-none">
          <legend class="sr-only"> What values does this member have? </legend>
          <label class="checkbox"><input name="sample[first]" type="hidden" value="no" autocomplete="off" /><input type="checkbox" value="yes" checked="checked" name="sample[first]" id="sample_first" /> First value </label>
          <label class="checkbox"><input name="sample[second]" type="hidden" value="no" autocomplete="off" /><input type="checkbox" value="yes" name="sample[second]" id="sample_second" /> Second value </label>
          <hr />
          <label class="checkbox"><input name="sample[none]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[none]" id="sample_none" /> None of the above </label>
        </fieldset>
        HTML
      end
    end

    context "when none_text is given a custom string" do
      it "sets uses the string for the none input label" do
        class SampleForm < Cfa::Styleguide::FormExample
          attr_accessor :first, :second, :none
        end

        sample = SampleForm.new(first: "1", second: "0")
        form = described_class.new("sample", sample, template, {})
        output = form.cfa_checkbox_set_with_none(
          :set_method_name,
          [
            { method: :first, label: "First value" },
            { method: :second, label: "Second value" },
          ],
          label_text: "What values does this member have?",
          none_text: "I don't have either of these",
        )

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group checkbox-none">
          <legend class="sr-only"> What values does this member have? </legend>
          <label class="checkbox"><input name="sample[first]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[first]" id="sample_first" /> First value </label>
          <label class="checkbox"><input name="sample[second]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" name="sample[second]" id="sample_second" /> Second value </label>
          <hr />
          <label class="checkbox"><input name="sample[none]" type="hidden" value="0" autocomplete="off" /><input type="checkbox" value="1" checked="checked" name="sample[none]" id="sample_none" /> I don't have either of these </label>
        </fieldset>
        HTML
      end
    end
  end

  describe "#cfa_radio_set" do
    it "renders an accessible set of radio inputs" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :selected_county_location

        validates_presence_of :selected_county_location
      end

      form = SampleForm.new
      form.validate
      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_radio_set(
        :selected_county_location,
        label_text: "Do you live in Arapahoe County?",
        collection: [
          { value: :arapahoe, label: "Yes" },
          { value: :not_arapahoe, label: "No" },
          { value: :not_sure, label: "I'm not sure" },
        ],
        help_text: "This is help text.",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group form-group--error" aria-describedby="form_selected_county_location__help-text form_selected_county_location__errors">
          <legend class="form-question ">
            Do you live in Arapahoe County?
          </legend>
          <p class="text--help" id="form_selected_county_location__help-text">This is help text.</p>
          <div class="input-group--block honeycrisp-radiogroup">
            <label class="radio-button"><div class="field_with_errors"><input type="radio" value="arapahoe" name="form[selected_county_location]" id="form_selected_county_location_arapahoe"/></div> Yes </label>
            <label class="radio-button"><div class="field_with_errors"><input type="radio" value="not_arapahoe" name="form[selected_county_location]" id="form_selected_county_location_not_arapahoe"/></div> No </label>
            <label class="radio-button"><div class="field_with_errors"><input type="radio" value="not_sure" name="form[selected_county_location]" id="form_selected_county_location_not_sure"/></div> I'm not sure </label>
          </div>
          <span class="text--error" id="form_selected_county_location__errors"><i class="icon-warning"></i> can't be blank </span>
        </fieldset>
      HTML
    end
  end

  describe "#cfa_radio_set_with_follow_up" do
    it "renders an accessible set of radio inputs" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :hourly, :wage, :salary

        validates_presence_of :hourly, :wage
      end

      form = SampleForm.new
      form.validate
      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_radio_set_with_follow_up(
        :hourly,
        label_text: "Do you work hourly?",
        collection: [
          { value: :yes, label: "Yes" },
          { value: :no, label: "No" },
        ],
        first_follow_up: -> { form_builder.cfa_input_field(:wage, "What is your hourly wage?") },
        second_follow_up: -> { form_builder.cfa_input_field(:salary, "What is your salary?") },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <div class="question-with-follow-up">
          <div class="question-with-follow-up__question">
            <fieldset class="form-group form-group--error" aria-describedby="form_hourly__errors">
            <legend class="form-question "> Do you work hourly? </legend>
              <div class="input-group--block honeycrisp-radiogroup">
                <label class="radio-button"><div class="field_with_errors"><input data-follow-up="#hourly-first-follow-up" type="radio" value="yes" name="form[hourly]" id="form_hourly_yes" /></div> Yes </label>
                <label class="radio-button"><div class="field_with_errors"><input data-follow-up="#hourly-second-follow-up" type="radio" value="no" name="form[hourly]" id="form_hourly_no" /></div> No </label>
              </div>
              <span class="text--error" id="form_hourly__errors"><i class="icon-warning"></i> can't be blank </span>
            </fieldset>
          </div>
          <div class="question-with-follow-up__follow-up" id="hourly-first-follow-up">
            <div class="form-group form-group--error">
              <div class="field_with_errors">
                <label for="form_wage">
                  <span class="form-question">What is your hourly wage?</span>
                </label>
              </div>
              <div class="field_with_errors">
                <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" aria-describedby="form_wage__errors" type="text" class="text-input" id="form_wage" name="form[wage]" />
              </div>
              <span class="text--error" id="form_wage__errors"><i class="icon-warning"></i> can't be blank </span>
            </div>
          </div>
          <div class="question-with-follow-up__follow-up" id="hourly-second-follow-up">
            <div class="form-group">
              <label for="form_salary">
                <span class="form-question">What is your salary?</span>
              </label>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" type="text" class="text-input" id="form_salary" name="form[salary]" />
            </div>
          </div>
        </div>
      HTML
    end
  end

  describe "#cfa_input_field" do
    it "renders a label that contains a p tag" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :money
      end

      form = SampleForm.new
      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_input_field(:money, "How much do you make?", prefix: "$", postfix: "/hr")
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label for="form_money">
            <span class="form-question">How much do you make?</span>
          </label>
          <div class="text-input-group-container">
            <div class="text-input-group">
              <div class="text-input-group__prefix">$</div>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" type="text" class="text-input" id="form_money" name="form[money]" />
              <div class="text-input-group__postfix">/hr</div>
             </div>
          </div>
        </div>
      HTML
    end

    it "adds help text and error ids to aria-describedby" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :name

        validates_presence_of :name
      end

      form = SampleForm.new
      form.validate

      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_input_field(
        :name,
        "How is name?",
        help_text: "Name is name",
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<~HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label for="form_name">
              <span class="form-question has-help">How is name?</span>
            </label>
          </div>
          <p class="text--help" id="form_name__help-text">Name is name</p>
          <div class="field_with_errors">
            <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" aria-describedby="form_name__help-text form_name__errors" type="text" class="text-input" id="form_name" name="form[name]" />
          </div>
          <span class="text--error" id="form_name__errors"><i class="icon-warning"></i> can't be blank </div>
        </div>
      HTML
    end
  end

  describe "#cfa_range_field" do
    class SampleForm < Cfa::Styleguide::FormExample
      attr_accessor :lower_hours_a_week_amount,
        :upper_hours_a_week_amount

      validates_presence_of :lower_hours_a_week_amount, :upper_hours_a_week_amount, message: "Please enter a range."
    end

    it "renders two text inputs for a range" do
      form = SampleForm.new
      form.lower_hours_a_week_amount = "ten"
      form.upper_hours_a_week_amount = "forty"

      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_range_field(
        :lower_hours_a_week_amount,
        :upper_hours_a_week_amount,
        "How many hours a week do you work?",
        help_text: "This is help text",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<~HTML
        <fieldset class="form-group" aria-describedby="form_lower_hours_a_week_amount_upper_hours_a_week_amount__help-text">
          <legend class="form-question "> How many hours a week do you work? </legend>
          <p class="text--help" id="form_lower_hours_a_week_amount_upper_hours_a_week_amount__help-text">This is help text</p>
          <div class="input-group--range">
            <div class="form-group">
              <label class="sr-only" for="form_lower_hours_a_week_amount">
                <span class="form-question">Lower amount</span>
              </label>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" type="text" value="ten" name="form[lower_hours_a_week_amount]" id="form_lower_hours_a_week_amount" />
            </div>
            <span class="range-text">to</span>
            <div class="form-group">
              <label class="sr-only" for="form_upper_hours_a_week_amount">
                <span class="form-question">Upper amount</span>
              </label>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" type="text" value="forty" name="form[upper_hours_a_week_amount]" id="form_upper_hours_a_week_amount" />
            </div>
          </div>
        </fieldset>
      HTML
    end

    it "renders two text inputs for a range in Spanish" do
      I18n.locale = :es
      form = SampleForm.new
      form.lower_hours_a_week_amount = "ten"
      form.upper_hours_a_week_amount = "forty"

      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_range_field(
        :lower_hours_a_week_amount,
        :upper_hours_a_week_amount,
        "¿Cuántas horas a la semana trabaja usted?",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<~HTML
        <fieldset class="form-group">
          <legend class="form-question "> ¿Cuántas horas a la semana trabaja usted? </legend>
          <div class="input-group--range">
            <div class="form-group">
              <label class="sr-only" for="form_lower_hours_a_week_amount">
                <span class="form-question">Menor cantidad</span>
              </label>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" type="text" value="ten" name="form[lower_hours_a_week_amount]" id="form_lower_hours_a_week_amount" />
            </div>
            <span class="range-text">a</span>
            <div class="form-group">
              <label class="sr-only" for="form_upper_hours_a_week_amount">
                <span class="form-question">Mayor cantidad</span>
              </label>
              <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" type="text" value="forty" name="form[upper_hours_a_week_amount]" id="form_upper_hours_a_week_amount" />
            </div>
          </div>
        </fieldset>
      HTML
    end

    context "with a validation error" do
      it "renders any individual errors as a shared error" do
        form = SampleForm.new
        form.lower_hours_a_week_amount = "ten"
        form.upper_hours_a_week_amount = nil
        form.validate

        form_builder = described_class.new("form", form, template, {})
        output = form_builder.cfa_range_field(
          :lower_hours_a_week_amount,
          :upper_hours_a_week_amount,
          "How many hours a week do you work?",
        )
        expect(output).to be_html_safe

        expect(output).to match_html <<~HTML
          <fieldset class="form-group form-group--error">
            <legend class="form-question "> How many hours a week do you work? </legend>
            <div class="input-group--range">
              <div class="form-group">
                <label class="sr-only" for="form_lower_hours_a_week_amount">
                  <span class="form-question">Lower amount</span>
                </label>
                <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" aria-describedby="form_lower_hours_a_week_amount_upper_hours_a_week_amount__errors" type="text" value="ten" name="form[lower_hours_a_week_amount]" id="form_lower_hours_a_week_amount" />
              </div>
              <span class="range-text">to</span>
              <div class="form-group">
                <div class="field_with_errors">
                  <label class="sr-only" for="form_upper_hours_a_week_amount">
                    <span class="form-question">Upper amount</span>
                  </label>
                </div>
                <div class="field_with_errors">
                  <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="text-input form-width--short" aria-describedby="form_lower_hours_a_week_amount_upper_hours_a_week_amount__errors" type="text" name="form[upper_hours_a_week_amount]" id="form_upper_hours_a_week_amount" />
                </div>
              </div>
            </div>
            <span id="form_lower_hours_a_week_amount_upper_hours_a_week_amount__errors" class="text--error"><i class="icon-warning"></i> Please enter a range. </span>
          </fieldset>
        HTML
      end
    end
  end

  describe "#cfa_date_select" do
    it "renders an accessible date select" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :birthday_year,
          :birthday_month,
          :birthday_day
      end

      form = SampleForm.new
      form.birthday_year = 1990
      form.birthday_month = 3
      form.birthday_day = 25
      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_date_select(
        :birthday,
        "What is your birthday?",
        help_text: "(For surprises)",
        options: {
          start_year: 1990,
          end_year: 1992,
          order: %i{month day year},
        },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group" aria-describedby="form_birthday__help-text">
          <legend class="form-question "> What is your birthday? </legend>
          <p class="text--help" id="form_birthday__help-text">(For surprises)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="form_birthday_month" class="sr-only">Month</label>
              <select id="form_birthday_month" name="form[birthday_month]" class="select__element">
                <option value="">Month</option>
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3" selected="selected">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_day" class="sr-only">Day</label>
              <select id="form_birthday_day" name="form[birthday_day]" class="select__element">
                <option value="">Day</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
                <option value="19">19</option>
                <option value="20">20</option>
                <option value="21">21</option>
                <option value="22">22</option>
                <option value="23">23</option>
                <option value="24">24</option>
                <option value="25" selected="selected">25</option>
                <option value="26">26</option>
                <option value="27">27</option>
                <option value="28">28</option>
                <option value="29">29</option>
                <option value="30">30</option>
                <option value="31">31</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_year" class="sr-only">Year</label>
              <select id="form_birthday_year" name="form[birthday_year]" class="select__element">
                <option value="">Year</option>
                <option value="1990" selected="selected">1990</option>
                <option value="1991">1991</option>
                <option value="1992">1992</option>
              </select>
            </div>
          </div>
        </fieldset>
      HTML
    end

    it "renders an accessible date select in Spanish" do
      I18n.locale = :es
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :birthday_year,
          :birthday_month,
          :birthday_day
      end

      form = SampleForm.new
      form.birthday_year = 1990
      form.birthday_month = 3
      form.birthday_day = 25
      form_builder = described_class.new("form", form, template, {})
      output = form_builder.cfa_date_select(
        :birthday,
        "¿Cuando es tu cumpleaños?",
        help_text: "(por sorpresas)",
        options: {
          start_year: 1990,
          end_year: 1992,
          order: %i{month day year},
        },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group" aria-describedby="form_birthday__help-text">
          <legend class="form-question "> ¿Cuando es tu cumpleaños? </legend>
          <p class="text--help" id="form_birthday__help-text">(por sorpresas)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="form_birthday_month" class="sr-only">Mes</label>
              <select id="form_birthday_month" name="form[birthday_month]" class="select__element">
                <option value="">Mes</option>
                <option value="1">enero</option>
                <option value="2">febrero</option>
                <option value="3" selected="selected">marzo</option>
                <option value="4">abril</option>
                <option value="5">mayo</option>
                <option value="6">junio</option>
                <option value="7">julio</option>
                <option value="8">agosto</option>
                <option value="9">septiembre</option>
                <option value="10">octubre</option>
                <option value="11">noviembre</option>
                <option value="12">diciembre</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_day" class="sr-only">Día</label>
              <select id="form_birthday_day" name="form[birthday_day]" class="select__element">
                <option value="">Día</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
                <option value="19">19</option>
                <option value="20">20</option>
                <option value="21">21</option>
                <option value="22">22</option>
                <option value="23">23</option>
                <option value="24">24</option>
                <option value="25" selected="selected">25</option>
                <option value="26">26</option>
                <option value="27">27</option>
                <option value="28">28</option>
                <option value="29">29</option>
                <option value="30">30</option>
                <option value="31">31</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_year" class="sr-only">Año</label>
              <select id="form_birthday_year" name="form[birthday_year]" class="select__element">
                <option value="">Año</option>
                <option value="1990" selected="selected">1990</option>
                <option value="1991">1991</option>
                <option value="1992">1992</option>
              </select>
            </div>
          </div>
        </fieldset>
      HTML
    end
  end

  describe "#cfa_textarea" do
    it "renders a label with the sr-only class when hide_label set to true" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :description

        validates_presence_of :description
      end
      sample = SampleForm.new
      sample.validate

      form = described_class.new("sample", sample, template, {})
      output = form.cfa_textarea(
        :description,
        "Write a lot?",
        help_text: "Name for texting",
        hide_label: true,
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label class="sr-only" for="sample_description">
              <span class="form-question has-help">Write a lot?</span>
            </label>
          </div>
        <p class="text--help sr-only" id="sample_description__help-text">Name for texting</p>
        <div class="field_with_errors">
          <textarea autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" class="textarea" aria-describedby="sample_description__help-text sample_description__errors" name="sample[description]" id="sample_description"></textarea>
        </div>
        <span class="text--error" id="sample_description__errors"><i class="icon-warning"></i> can't be blank </span>
       </div>
      HTML
    end
  end

  describe "#cfa_single_tap_button" do
    it "renders an submit button with given value" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :anyone_home
      end

      sample = SampleForm.new
      form = described_class.new("sample", sample, template, {})
      output = form.cfa_single_tap_button(
        :anyone_home,
        "Yes",
        true,
        classes: ["foo"],
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <button name="sample[anyone_home]" type="submit" value="true" class="foo button">Yes</button>
      HTML
    end
  end

  describe "#cfa_select" do
    it "renders a range of numeric options with a screen-reader only label" do
      class SampleForm < Cfa::Styleguide::FormExample
        attr_accessor :how_many

        validates_presence_of :how_many
      end

      sample = SampleForm.new
      sample.validate
      form = described_class.new("sample", sample, template, {})
      output = form.cfa_select(
        :how_many,
        "This is for screen readers!",
        (0..10).map { |number| ["#{number} thing".pluralize(number), number] },
        hide_label: true,
        help_text: "Choose how many",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<~HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label class="sr-only" for="sample_how_many">
              <span class="form-question has-help">This is for screen readers!</span>
            </label>
          </div>
          <p class="text--help sr-only" id="sample_how_many__help-text">Choose how many</p>
          <div class="select">
            <div class="field_with_errors">
              <select class="select__element" aria-describedby="sample_how_many__help-text sample_how_many__errors" name="sample[how_many]" id="sample_how_many">
                <option value="0">0 things</option>
                <option value="1">1 thing</option>
                <option value="2">2 things</option>
                <option value="3">3 things</option>
                <option value="4">4 things</option>
                <option value="5">5 things</option>
                <option value="6">6 things</option>
                <option value="7">7 things</option>
                <option value="8">8 things</option>
                <option value="9">9 things</option>
                <option value="10">10 things</option>
              </select>
            </div>
          </div>
          <span class="text--error" id="sample_how_many__errors"><i class="icon-warning"></i> can't be blank </span>
        </div>
      HTML
    end
  end
end
