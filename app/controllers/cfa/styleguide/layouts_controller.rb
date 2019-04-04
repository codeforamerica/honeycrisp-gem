module Cfa
  module Styleguide
    class LayoutsController < ApplicationController
      helper Cfa::Styleguide::PagesHelper
      layout 'main'

      def index
      end

      def center_aligned
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def left_aligned
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def confirmation
      end

      def progress_signpost
      end

      def review_signpost
        @rent_for_review = '600' # Save data for review with this instance variable
        @utilities_for_review = '50'
      end

      def graphic_signpost
        @income = '3000'
        @status = 'ineligible'
      end

      def yes_no_signpost
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end
    end
  end
end