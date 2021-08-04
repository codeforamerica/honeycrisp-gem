require "spec_helper"

# TODO: refactor to smaller feature spec when we add Jest JavaScript unit tests
describe "Reveal" do
  before do
    visit "cfa/styleguide/examples/molecules/reveal"
  end

  describe "default view" do
    it "on page load, trigger is visible and content is not", js: true do
      expect(page).to have_content "Learn more about student eligibility"
      expect(page).not_to have_content "In order to qualify as a college student, you have to meet one of the following exemptions:"
    end
  end

  describe "show reveal content" do
    it "reveals content when the reveal link is clicked", js: true do
      click_on "Learn more about student eligibility"

      expect(page).to have_content "In order to qualify as a college student, you have to meet one of the following exemptions:"
      expect(page).to have_content "Work an average at least 20 hours a week"
    end
  end

  describe "hide reveal content" do
    it "hides content when the reveal link is clicked with content already showing", js: true do
      click_on "Learn more about student eligibility"
      click_on "Learn more about student eligibility"

      expect(page).not_to have_content "In order to qualify as a college student, you have to meet one of the following exemptions:"
    end
  end
end
