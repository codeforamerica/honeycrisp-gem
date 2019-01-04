module Cfa
  module Styleguide
    class PagesController < ApplicationController
      layout "main"

      def form_builder
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end
    end
  end
end
