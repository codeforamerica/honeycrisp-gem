module Cfa
  module Styleguide
    class PagesController < ApplicationController
      layout "main"

      def form_builder
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def emojis
        @emojis = Dir.chdir(File.expand_path('../../../assets/images', File.dirname(__FILE__))) do
          Dir.glob('emojis/*')
        end
        @emoji_pairs = Dir.chdir(File.expand_path('../../../assets/images/', File.dirname(__FILE__))) do
          Dir.glob('emoji_pairs/*')
        end
      end
    end
  end
end
