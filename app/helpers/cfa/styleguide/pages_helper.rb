module Cfa
  module Styleguide
    module PagesHelper
      def styleguide_example
        content_tag :div, class: 'pattern' do
          content_tag :div, class: 'pattern__example' do
            yield
          end
        end
      end

      def styleguide_example_with_code(code, f = nil)
        # This `f` arg is sneaky -- it's the form context for CfAFormBuilder, and ERB will need
        # it when we are trying to render form elements (e.g. `f.cfa_input_field`)
        content = styleguide_example { ERB.new("<%= #{code} %>").result(binding).html_safe }
        content << styleguide_described_code(code)
      end

      def styleguide_described_code(code)
        content_tag(:div, class: 'pattern__code') do
          content_tag(:pre, class: 'language-ruby language-markup') do
            content_tag(:code, class: 'language-ruby') do
              code
            end
          end
        end
      end

      def status_icon(icon, successful: false, failure: false, not_applicable: false)
        classes = ["status"]
        classes << "successful" if successful
        classes << "failure" if failure
        classes << "not-applicable" if not_applicable
        classes << "icon-" + icon

        <<-HTML.html_safe
      <i class="#{classes.join(' ')}" aria-hidden='true'></i>
        HTML
      end
    end
  end
end
