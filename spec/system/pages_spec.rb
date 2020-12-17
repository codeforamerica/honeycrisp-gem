require "spec_helper"

describe "Pages" do
  it "the test app root path redirects to /cfa/styleguide" do
    visit "/"

    expect(current_path).to eq "/cfa/styleguide"
  end

  it "can load styleguide" do
    visit "/cfa/styleguide"

    expect(page.status_code).to eq 200
    expect(page).to have_content("Honeycrisp Design System v#{Cfa::Styleguide::VERSION}")
  end

  it "can load the compact styleguide" do
    visit "/cfa/styleguide"
    within ".sidebar-nav" do
      click_on "Honeycrisp Compact"
    end

    expect(page.status_code).to eq 200
    expect(page).to have_content("Honeycrisp Compact is a variation of Honeycrisp.")
  end

  it "can load emoji index" do
    visit "/cfa/styleguide"
    click_on "Emojis"

    expect(page.status_code).to eq 200
    expect(page).to have_content("Emojis")
  end

  it "can use the CfaFormBuilder" do
    visit "/cfa/styleguide"
    click_link "Form Builder"

    expect(page).to have_content("Example input")
    expect(page).to have_content("Example textarea")
    expect(page).to have_content("Example range")
    expect(page).to have_content("Example date select")

    expect(page).to have_content("Example choice 1")
    expect(page).to have_content("Example choice 2")
    expect(page).to have_content("Example radio set (regular)")
    expect(page).to have_content("Example radio set with follow up")
    expect(page).to have_content("Example select")
  end
end
