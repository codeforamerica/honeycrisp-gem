module Cfa
  module Styleguide
    class Engine < ::Rails::Engine
      require 'prism-rails'

      isolate_namespace Cfa::Styleguide

      initializer "cfa-styleguide.assets.precompile" do |app|
        app.config.assets.precompile += %w(
          cfa_styleguide_main.css
          cfa_styleguide_main.js
          prism.js
          prism.css
        )
      end

      config.generators do |g|
        g.test_framework :rspec
      end
    end
  end
end
