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
    end
  end
end