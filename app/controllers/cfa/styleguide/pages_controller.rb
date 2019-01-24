module Cfa
  module Styleguide
    class PagesController < ApplicationController
      layout "main"

      def form_builder
        @form = Cfa::Styleguide::FormExample.new
        @form.valid?
      end

      def emojis
        classes = Dir.chdir(File.expand_path('../../../assets/stylesheets/atoms', File.dirname(__FILE__))) do
          File.read('_emoji.scss').scan(/\.(\S*) {.*/)
        end
        emojis = []
        emoji_pairs = []

        classes.each do |c|
          if c[0].include?('emoji-pair')
            emoji_pairs.push(c[0])
          else
            emojis.push(c[0])
          end
        end

        emojis
        emoji_pairs

        @emojis = emojis
        @emoji_pairs = emoji_pairs
      end
    end
  end
end
