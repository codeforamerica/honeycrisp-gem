require "spec_helper"

describe "Examples" do
  it "can render out a specific example" do
    visit "/cfa/styleguide/examples/molecules/progress_step_bar"

    expect(page.status_code).to eq 200
  end

  each_example do |example, example_path|
    describe example do
      it "has a Percy snapshot", js: true do
        visit example_path
        percy_snapshot example
      end
    end
  end
end
