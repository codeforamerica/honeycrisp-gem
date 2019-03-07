module Cfa
  module Styleguide
    class LayoutsController < ApplicationController
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
        @current_step = 3
        @step_count = 5
      end

      def review_signpost
        @info_card_type = 'review'
        @content_for_review = '600' # Save data for review with this instance variable
      end

      def graphic_signpost
        @info_card_type = 'graphic'
        @income = '3000'
        @status = 'ineligible'
      end
    end
  end
end