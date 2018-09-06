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
