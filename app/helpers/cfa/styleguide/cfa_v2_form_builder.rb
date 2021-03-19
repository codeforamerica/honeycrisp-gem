module Cfa
  module Styleguide
    class CfaV2FormBuilder < ActionView::Helpers::FormBuilder
      def cfa_button(label_text, wrapper_options: {}, **input_options)
        wrapper_options = append_to_value(wrapper_options, :class, "cfa-button")
        @template.tag.div(wrapper_options) do
          button(label_text, { class: "button button--primary" }.merge(input_options))
        end
      end

      def cfa_text_field(method,
                         label_text,
                         help_text: nil,
                         wrapper_options: {},
                         label_options: {},
                         **input_options)
        if help_text.present?
          help_text_id = help_text_id(method)
          help_text_html = help_text_html(help_text, help_text_id)
          input_options = append_to_value(input_options, :'aria-describedby', help_text_id)
        end

        if object.errors[method].any?
          error_id = error_id(method)
          error_html = errors_for(object, method, error_id)
          wrapper_options = append_to_value(wrapper_options, :class, "form-group--error")
          input_options = append_to_value(input_options, :'aria-describedby', error_id)
        end

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-text-field form-group")
        label_options = append_to_value(label_options, :class, "form-question")
        input_options = append_to_value(input_options, :class, "text-input")

        @template.tag.div(wrapper_options) do
          @template.concat(label(method, errors_and_optional_annotation(method, label_text, input_options[:required]), label_options))
          @template.concat(help_text_html)
          @template.concat(text_field(method, input_options))
          @template.concat(error_html)
        end
      end

      def cfa_select(
          method,
          label_text,
          choices,
          select_options: {},
          wrapper_options: {},
          label_options: {},
          **select_html_options,
          &block
        )
        if object.errors[method].any?
          error_id = error_id(method)
          error_html = errors_for(object, method, error_id)
          wrapper_options = append_to_value(wrapper_options, :class, "form-group--error")
          select_html_options = append_to_value(select_html_options, :'aria-describedby', error_id)
        end

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-select form-group")
        label_options = append_to_value(label_options, :class, "form-question")
        select_html_options = append_to_value(select_html_options, :class, "select__element")

        @template.tag.div(wrapper_options) do
          @template.concat(label(method, errors_and_optional_annotation(method, label_text, select_html_options[:required]), label_options))
          @template.concat(@template.tag.div(class: "select") do
            @template.concat(select(method, choices, select_options, select_html_options, &block))
          end)
          @template.concat(error_html&.html_safe)
        end
      end

      def cfa_fieldset(method,
                       legend_text,
                       wrapper_options: {},
                       label_options: {},
                       **fieldset_html_options,
                       &block)

        if object.errors[method].any?
          error_id = error_id(method)
          label_options = append_to_value(label_options, :'aria-describedby', error_id)
          wrapper_options = append_to_value(wrapper_options, :class, "form-group--error")
        end

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-fieldset form-group")
        label_options = append_to_value(label_options, :class, "form-question")

        @template.tag.div(wrapper_options) do
          @template.tag.fieldset(fieldset_html_options) do
            @template.concat(@template.tag.legend(errors_and_optional_annotation(method, legend_text, fieldset_html_options[:required]), label_options))
            @template.concat(@template.capture(&block)) if block_given?
            @template.concat(errors_for(object, method, error_id)) if object.errors[method].any?
          end
        end
      end

      # Note: there is no errored state for an individual button.
      # This is intended to be used within a cfa_fieldset
      def cfa_radio_button(method,
                           label_text,
                           value,
                           wrapper_options: {},
                           label_options: {},
                           **input_options)

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-radio-button")
        label_options = append_to_value(label_options, :class, "radio-button")

        @template.tag.div(wrapper_options) do
          @template.tag.label(label_options) do
            @template.concat(radio_button(method, value, input_options))
            @template.concat(label_text)
          end
        end
      end

      def cfa_collection_radio_buttons(method,
                                       collection,
                                       value_method,
                                       text_method,
                                       wrapper_options: {},
                                       label_options: {},
                                       **input_options)

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-collection-radio-buttons")
        label_options = append_to_value(label_options, :class, "radio-button")

        @template.tag.div(wrapper_options) do
          collection_radio_buttons(method, collection, value_method, text_method) do |b|
            b.label(label_options) { b.radio_button(input_options) + b.text }
          end
        end
      end

      # Note: there is no errored state for an individual checkbox.
      # This is intended to be used within a cfa_fieldset
      def cfa_check_box(method,
                        label_text,
                        checked_value = "1",
                        unchecked_value = "0",
                        wrapper_options: {},
                        label_options: {},
                        **input_options)

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-check-box")
        label_options = append_to_value(label_options, :class, "checkbox")

        @template.tag.div(wrapper_options) do
          @template.concat(@template.tag.label(label_options) do
            @template.concat(check_box(method, input_options, checked_value, unchecked_value))
            @template.concat(label_text)
          end)
        end
      end

      def cfa_collection_check_boxes(method,
                                     collection,
                                     value_method,
                                     text_method,
                                     wrapper_options: {},
                                     label_options: {},
                                     **input_options)

        wrapper_options = append_to_value(wrapper_options, :class, "cfa-collection-check-boxes")
        label_options = append_to_value(label_options, :class, "checkbox")
        @template.tag.div(wrapper_options) do
          collection_check_boxes(method, collection, value_method, text_method) do |b|
            b.label(label_options) { b.check_box(input_options) + b.text }
          end
        end
      end

      private

      def help_text_html(help_text, help_text_id)
        <<~HTML.html_safe
          <div class="text--help" id="#{help_text_id}">
            #{help_text}
          </div>
        HTML
      end

      def errors_and_optional_annotation(method, label_text, required)
        output_string = ""
        output_string.concat(<<~HTML.html_safe) if object.errors[method].any?
          <span class="sr-only">Validation error</span>
        HTML
        output_string.concat(label_text)
        output_string.concat(<<~HTML.html_safe) unless required
          <span class="form-question--optional"></span>
          <span class="sr-only">(Optional)</span>
        HTML
        output_string.html_safe
      end

      def errors_for(object, method, error_id)
        errors = object.errors[method]
        <<~HTML.html_safe
          <div class="text--error" id="#{error_id}">
            <i class="icon-warning"></i>
            #{errors.join(', ')}
          </div>
        HTML
      end

      def append_to_value(input_options, key, appending_value)
        initial_value = input_options[key]
        new_value = [initial_value, appending_value].compact.join(" ")
        input_options.merge({ key => new_value })
      end

      def help_text_id(method)
        "#{sanitized_id(method)}__help-text"
      end

      def error_id(method)
        "#{sanitized_id(method)}__errors"
      end

      def sanitized_id(method, position = nil)
        name = object_name.to_s.gsub(/([\[\(])|(\]\[)/, "_").gsub(/[\]\)]/, "")

        position ? "#{name}_#{method}_#{position}" : "#{name}_#{method}"
      end
    end
  end
end
