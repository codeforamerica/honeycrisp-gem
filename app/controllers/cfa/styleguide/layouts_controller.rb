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
    end
  end
end