module Cfa
  module Styleguide
    class PagesController < ApplicationController
      layout "main"

      def form_builder_v1
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def form_builder_v2
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def emojis
        classes = Dir.chdir(File.expand_path("../../../assets/stylesheets/atoms", File.dirname(__FILE__))) do
          File.read("_emoji.scss").scan(/\.(\S*) {.*/)
        end
        @emojis = []
        @emoji_pairs = []

        classes.each do |css_class|
          if css_class[0].include?("emoji-pair")
            @emoji_pairs.push(css_class[0])
          else
            @emojis.push(css_class[0])
          end
        end
      end
    end
  end
end
