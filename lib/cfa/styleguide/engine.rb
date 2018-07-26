module Cfa
  module Styleguide
    class Engine < ::Rails::Engine
      isolate_namespace Cfa::Styleguide

      config.generators do |g|
        g.test_framework :rspec
      end
    end
  end
end
