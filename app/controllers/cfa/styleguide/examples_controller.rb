module Cfa
  module Styleguide
    class ExamplesController < ApplicationController
      layout false

      def show
        @partial_path = "examples/#{params[:example_path]}"
      end
    end
  end
end
