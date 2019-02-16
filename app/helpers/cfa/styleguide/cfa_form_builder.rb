module Cfa
  module Styleguide
    class CfaFormBuilder < ActionView::Helpers::FormBuilder
      include ActionView::Helpers::DateHelper

      def cfa_checkbox(method, label_text, options: {})
        checked_value = options[:checked_value] || "1"
        unchecked_value = options[:unchecked_value] || "0"

        classes = ["checkbox"]
        if options[:disabled] && object.public_send(method) == checked_value
          classes.push("is-selected")
        end
        if options[:disabled]
          classes.push("is-disabled")
        end

        options_with_errors = options.merge(error_attributes(method: method))
        <<~HTML.html_safe
          <fieldset class="input-group form-group#{error_state(object, method)}">
            <label class="#{classes.join(' ')}">
              #{check_box(method, options_with_errors, checked_value, unchecked_value)} #{label_text}
            </label>
            #{errors_for(object, method)}
          </fieldset>
        HTML
      end

      def cfa_checkbox_set(
        method,
        collection,
        label_text: "",
        help_text: nil,
        optional: false,
        legend_class: ""
      )
        checkbox_html = collection.map do |item|
          <<~HTML.html_safe
            <label class="checkbox">
              #{check_box(item[:method])} #{item[:label]}
            </label>
          HTML
        end.join.html_safe

        <<~HTML.html_safe
          <fieldset class="input-group form-group#{error_state(object, method)}">
            #{fieldset_label_contents(
              label_text: label_text,
              help_text: help_text,
              legend_class: legend_class,
              optional: optional,
            )}
            #{checkbox_html}
            #{errors_for(object, method)}
          </fieldset>
        HTML
      end

      def cfa_checkbox_set_with_none(
        method,
        collection,
        label_text: nil,
        enum: false,
        none_text: "None of the above",
        options: {}
      )

        checkbox_collection_html = collection.map do |item|
          checkbox_html = if enum
                            check_box(item[:method], options, "yes", "no")
                          else
                            check_box(item[:method], options)
                          end

          <<~HTML.html_safe
            <label class="checkbox">
              #{checkbox_html} #{item[:label]}
            </label>
          HTML
        end.join.html_safe

        <<~HTML.html_safe
          <fieldset class="input-group form-group#{error_state(object, method)}">
            <legend class="sr-only">
              #{label_text}
            </legend>
            #{checkbox_collection_html}
            <label class="checkbox">
              #{check_box(:none, options.merge(id: 'none__checkbox'))} #{none_text}
            </label>
            #{errors_for(object, method)}
          </fieldset>
        HTML
      end

      def cfa_input_field(
        method,
        label_text,
        type: "text",
        help_text: nil,
        options: {},
        classes: [],
        prefix: nil,
        postfix: nil,
        autofocus: nil,
        optional: false,
        notice: nil
      )
        text_field_options = standard_options.merge(
          autofocus: autofocus,
          type: type,
          class: (classes + ["text-input"]).join(" "),
        ).merge(options).merge(error_attributes(method: method))

        text_field_options[:id] ||= sanitized_id(method)
        options[:input_id] ||= sanitized_id(method)

        text_field_html = text_field(method, text_field_options)

        label_and_field_html = label_and_field(
          method,
          label_text,
          text_field_html,
          help_text: help_text,
          prefix: prefix,
          postfix: postfix,
          optional: optional,
          options: options,
          notice: notice,
          wrapper_classes: classes,
        )

        html_output = <<~HTML
          <div class="form-group#{error_state(object, method)}">
          #{label_and_field_html}
            #{errors_for(object, method)}
          </div>
        HTML
        html_output.html_safe
      end

      def cfa_radio_set(
        method,
        label_text: "",
        collection:,
        help_text: nil,
        layouts: ["block"],
        legend_class: ""
      )
        <<~HTML.html_safe
          <fieldset class="form-group#{error_state(object, method)}">
            #{fieldset_label_contents(
              label_text: label_text,
              help_text: help_text,
              legend_class: legend_class,
            )}
          #{cfa_radio_button(method, collection, layouts)}
          #{errors_for(object, method)}
          </fieldset>
        HTML
      end

      def cfa_radio_set_with_follow_up(
        method,
        label_text: "",
        collection:,
        help_text: nil,
        layouts: ["block"],
        legend_class: "",
        first_follow_up: nil,
        second_follow_up: nil
      )
        first_follow_up_html = if first_follow_up
                                 first_follow_up_id = "#{method}-first-follow-up"
                                 collection.first[:input_html] = { "data-follow-up" => "##{first_follow_up_id}" }

                                 <<~HTML.html_safe
                                   <div class="question-with-follow-up__follow-up" id="#{first_follow_up_id}">
                                     #{first_follow_up.()}
                                   </div>
                                 HTML
                               end

        second_follow_up_html = if second_follow_up
                                  second_follow_up_id = "#{method}-second-follow-up"
                                  collection.second[:input_html] = { "data-follow-up" => "##{second_follow_up_id}" }

                                  <<~HTML.html_safe
                                    <div class="question-with-follow-up__follow-up" id="#{second_follow_up_id}">
                                      #{second_follow_up.()}
                                    </div>
                                  HTML
                                end

        <<~HTML.html_safe
          <div class="question-with-follow-up">
            <div class="question-with-follow-up__question">
              #{cfa_radio_set(method,
                              label_text: label_text,
                              collection: collection,
                              help_text: help_text,
                              layouts: layouts,
                              legend_class: legend_class)}
            </div>
            #{[first_follow_up_html, second_follow_up_html].compact.join}
          </div>
        HTML
      end

      def cfa_range_field(lower_method, upper_method, label_text, help_text: nil)
        e_messages = object.errors.messages
        lower_error = e_messages[lower_method.to_sym]
        upper_error = e_messages[upper_method.to_sym]
        range_error_methods = [lower_method, upper_method].join("_")
        range_errors_present = lower_error.present? || upper_error.present?
        range_error_html = <<~HTML.html_safe
          <span id="#{error_label(range_error_methods)}" class="text--error">
            <i class="icon-warning"></i>
            #{[lower_error, upper_error].uniq.join}
          </span>
        HTML

        text_field_options = standard_options.merge(
          class: "text-input form-width--short",
        ).merge(error_attributes(method: range_error_methods))

        <<~HTML.html_safe
          <fieldset class="form-group#{' form-group--error' if range_errors_present}">
            #{fieldset_label_contents(label_text: label_text, help_text: help_text)}
            <div class="input-group--range">
              <div class="form-group">
                #{label_and_field(lower_method, 'Lower amount', text_field(lower_method, text_field_options), options: { class: 'sr-only' })}
              </div>
              <span class="range-text">to</span>
              <div class="form-group">
                #{label_and_field(upper_method, 'Upper amount', text_field(upper_method, text_field_options), options: { class: 'sr-only' })}
              </div>
            </div>
            #{range_error_html if range_errors_present}
          </fieldset>
        HTML
      end

      def cfa_date_select(
        method,
        label_text,
        help_text: nil,
        options: {},
        autofocus: nil
      )

        <<~HTML.html_safe
          <fieldset class="form-group#{error_state(object, method)}">
            #{fieldset_label_contents(label_text: label_text, help_text: help_text)}
            <div class="input-group--inline">
              <div class="select">
                <label for="#{sanitized_id(method, 'month')}" class="sr-only">Month</label>
                #{select_month(
                  OpenStruct.new(month: object.send(subfield_name(method, 'month')).to_i),
              { field_name: subfield_name(method, 'month'),
                field_id: subfield_id(method, 'month'),
                prefix: object_name,
                prompt: 'Month' }.reverse_merge(options),
              class: 'select__element',
              autofocus: autofocus,
                )}
              </div>
              <div class="select">
                <label for="#{sanitized_id(method, 'day')}" class="sr-only">Day</label>
                 #{select_day(
                   OpenStruct.new(day: object.send(subfield_name(method, 'day')).to_i),
              { field_name: subfield_name(method, 'day'),
                field_id: subfield_id(method, 'day'),
                prefix: object_name,
                prompt: 'Day' }.merge(options),
              class: 'select__element',
                 )}
              </div>
              <div class="select">
                <label for="#{sanitized_id(method, 'year')}" class="sr-only">Year</label>
                #{select_year(
                  OpenStruct.new(year: object.send(subfield_name(method, 'year')).to_i),
              { field_name: subfield_name(method, 'year'),
                field_id: subfield_id(method, 'year'),
                prefix: object_name,
                prompt: 'Year' }.merge(options),
              class: 'select__element',
                )}
              </div>
            </div>
            #{errors_for(object, method)}
          </fieldset>
        HTML
      end

      def cfa_textarea(
        method,
        label_text,
        help_text: nil,
        options: {},
        classes: [],
        autofocus: nil,
        hide_label: false,
        optional: false
      )
        classes = classes.append(%w[textarea])
        text_options = standard_options.merge(
          autofocus: autofocus,
          class: classes.join(" "),
        ).merge(options).merge(error_attributes(method: method))

        <<~HTML.html_safe
          <div class="form-group#{error_state(object, method)}">
            #{label_and_field(
              method,
              label_text,
              text_area(
                method,
                text_options,
              ),
              help_text: help_text,
              optional: optional,
              options: { class: hide_label ? 'sr-only' : '' },
            )}
            #{errors_for(object, method)}
          </div>
        HTML
      end

      def cfa_single_tap_button(method, label_text, value, classes: [])
        button(label_text.html_safe, name: "#{object_name}[#{method}]", value: value, class: classes.push("button").join(" "))
      end

      def cfa_select(
        method,
        label_text,
        collection,
        options = {},
        &block
      )

        html_options = {
          class: "select__element",
        }

        formatted_label = label(
          method,
          label_contents(
            label_text,
            options[:help_text],
            options[:optional],
          ),
          class: options[:hide_label] ? "sr-only" : "",
        )
        html_options_with_errors = html_options.merge(error_attributes(method: method))

        html_output = <<~HTML
          <div class="form-group#{error_state(object, method)}">
            #{formatted_label}
            <div class="select">
              #{select(method, collection, options, html_options_with_errors, &block)}
            </div>
            #{errors_for(object, method)}
          </div>
        HTML

        html_output.html_safe
      end

      private

      def standard_options
        {
          autocomplete: "off",
          autocorrect: "off",
          autocapitalize: "off",
          spellcheck: "false",
        }
      end

      def cfa_radio_button(method, collection, layouts)
        classes = layouts.map { |layout| "input-group--#{layout}" }.join(" ")
        options = { class: classes }.merge(error_attributes(method: method))

        radiogroup_tag = @template.tag(:radiogroup, options, true)

        radio_collection = collection.map do |item|
          item = { value: item, label: item } unless item.is_a?(Hash)

          input_html = item.fetch(:input_html, {})

          <<~HTML.html_safe
            <label class="radio-button">
              #{radio_button(method, item[:value], input_html)}
              #{item[:label]}
            </label>
          HTML
        end
        <<~HTML.html_safe
          #{radiogroup_tag}
                  #{radio_collection.join}
                      </radiogroup>
        HTML
      end

      def fieldset_label_contents(
        label_text:,
        help_text:,
        legend_class: "",
        optional: false
      )

        label_html = <<~HTML
          <legend class="form-question #{legend_class}">
            #{label_text + optional_text(optional)}
          </legend>
        HTML

        if help_text
          label_html += <<~HTML
            <p class="text--help">#{help_text}</p>
          HTML
        end

        label_html.html_safe
      end

      def label_contents(label_text, help_text, optional = false)
        label_text = <<~HTML
          <p class="form-question">#{label_text + optional_text(optional)}</p>
        HTML

        if help_text
          label_text << <<~HTML
            <p class="text--help">#{help_text}</p>
          HTML
        end

        label_text.html_safe
      end

      def optional_text(optional)
        if optional
          "<em class='card__optional'> Optional</em>"
        else
          ""
        end
      end

      def label_and_field(
        method,
        label_text,
        field,
        help_text: nil,
        prefix: nil,
        postfix: nil,
        optional: false,
        options: {},
        notice: nil,
        wrapper_classes: []
      )
        if options[:input_id]
          for_options = options.merge(
            for: options[:input_id],
          )
          for_options.delete(:input_id)
          for_options.delete(:maxlength)
        end

        formatted_label = label(
          method,
          label_contents(label_text, help_text, optional),
          (for_options || options),
        )
        formatted_label += notice_html(notice).html_safe if notice

        formatted_label + formatted_field(prefix, field, postfix, wrapper_classes).html_safe
      end

      def formatted_field(prefix, field, postfix, wrapper_classes)
        prefix_html = "<div class=\"text-input-group__prefix\">#{prefix}</div>" if prefix
        postfix_html = "<div class=\"text-input-group__postfix\">#{postfix}</div>" if postfix

        if prefix || postfix
          content_parts = [
            prefix_html,
            field,
            postfix_html,
          ]

          <<-HTML
        <div class="text-input-group-container">
          <div class="#{(['text-input-group'] + wrapper_classes).join(' ')}">
            #{content_parts.join}
          </div>
        </div>
          HTML
        else
          field
        end
      end

      def errors_for(object, method)
        errors = object.errors[method]
        if errors.any?
          <<~HTML
            <span class="text--error" id="#{error_label(method)}">
              <i class="icon-warning"></i>
              #{errors.join(', ')}
            </span>
          HTML
        end
      end

      def notice_html(notice_text)
        <<~HTML
          <div class="notice grid">
            <div class="grid__item width-one-twelfth">
              <i class="illustration illustration--safety"></i>
            </div>
            <div class="grid__item width-five-sixths">
              #{notice_text}
            </div>
          </div>
        HTML
      end

      def error_state(object, method)
        errors = object.errors[method]
        " form-group--error" if errors.any?
      end

      def subfield_id(method, position)
        "#{method}_#{position}"
      end

      def subfield_name(method, position)
        "#{method}_#{position}"
      end

      def sanitized_id(method, position = nil)
        name = object_name.to_s.gsub(/([\[\(])|(\]\[)/, "_").gsub(/[\]\)]/, "")

        position ? "#{name}_#{method}_#{position}" : "#{name}_#{method}"
      end

      def aria_label(method)
        "#{sanitized_id(method)}__label"
      end

      def error_label(method)
        "#{sanitized_id(method)}__errors"
      end

      def error_attributes(method:)
        object.errors.present? ? { "aria-describedby": error_label(method) } : {}
      end

      # copied from ActionView::FormHelpers in order to coerce strings with spaces
      # and capitalization to snake case, using the same logic as Rails
      def sanitized_value(value)
        value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase.to_s
      end
    end
  end
end
