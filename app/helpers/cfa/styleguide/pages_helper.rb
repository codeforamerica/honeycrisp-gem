module Cfa
  module Styleguide
    module PagesHelper
      def render_example(partial_path)
        partial = lookup_context.find_template(partial_path, [], true)

        content_tag :div, class: "pattern__example" do
          partial.render(self, {})
        end
      end

      def code_example_html(partial_path)
        partial = lookup_context.find_template(partial_path, [], true)

        partial.render(self, {})
      end

      def code_example_erb(partial_path)
        partial = lookup_context.find_template(partial_path, [], true)

        filepath = partial.identifier
        partial_contents = File.open(filepath, "r", &:read)

        partial_contents
      end

      def status_icon(icon, successful: false, failure: false, not_applicable: false)
        classes = ["status"]
        classes << "successful" if successful
        classes << "failure" if failure
        classes << "not-applicable" if not_applicable
        classes << "icon-#{icon}"

        <<-HTML.html_safe
      <i class="#{classes.join(' ')}" aria-hidden='true'></i>
        HTML
      end
    end
  end
end
