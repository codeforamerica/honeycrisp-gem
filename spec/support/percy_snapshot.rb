require "percy"

module PercySnapshot
  def percy_snapshot(name)
    if ENV["PERCY_TOKEN"].present?
      Percy.snapshot(page, name: name)
    end
  end
end

RSpec.configure do |config|
  config.include PercySnapshot, type: :system
end
