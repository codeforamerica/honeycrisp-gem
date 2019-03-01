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
    end
  end
end