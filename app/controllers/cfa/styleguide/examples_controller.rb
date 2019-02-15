module Cfa
  module Styleguide
    class ExamplesController < ApplicationController
      layout false

      def show
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?

        @partial_path = "examples/#{params[:example_path]}"
      end
    end
  end
end
