require "spec_helper"

describe "Examples" do
  it "can render out a specific example" do
    visit "/cfa/styleguide/examples/molecules/progress_step_bar"

    expect(page.status_code).to eq 200
  end
end
