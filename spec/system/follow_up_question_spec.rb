require "spec_helper"

describe "Follow up questions" do
  before do
    visit "cfa/styleguide/examples/molecules/follow_up_question"
  end

  describe "checkbox set" do
    it "reveals the follow up question when the right checkbox is selected", js: true do
      expect(page).not_to have_content "Please specify"

      check "Other"

      expect(page).to have_content "Please specify"

      check "Blue"

      expect(page).to have_content "Please specify"

      uncheck "Other"

      expect(page).not_to have_content "Please specify"
    end
  end

  describe "radio set" do
    it "reveals the follow up question when the right radio button is selected", js: true do
      expect(page).not_to have_content "Do you know why?"

      choose "No"

      expect(page).to have_content "Do you know why?"

      choose "Yes"

      expect(page).not_to have_content "Do you know why?"
    end
  end
end
