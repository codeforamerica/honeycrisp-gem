require "percy/capybara"

module PercySnapshot
  def percy_snapshot(name)
    if ENV["PERCY_TOKEN"].present?
      page.percy_snapshot(name)
    end
  end
end

RSpec.configure do |config|
  config.include PercySnapshot, type: :system
end
