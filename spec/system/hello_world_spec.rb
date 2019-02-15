require "spec_helper"

describe "Hello World" do
  it "can access standard cfa css" do
    visit "/assets/cfa_styleguide_main.css"

    expect(page.status_code).to eq 200
  end

  it "can access standard cfa js" do
    visit "/assets/cfa_styleguide_main.js"

    expect(page.status_code).to eq 200
  end
end
