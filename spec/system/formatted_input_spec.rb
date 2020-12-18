require "spec_helper"

describe "Autoformatted input fields" do
  before do
    visit "cfa/styleguide/examples/atoms/form_elements"
  end

  describe "SSN input fields" do
    it "can auto-format an SSN", js: true do
      fill_in "ssn", with: "111223333"

      expect(page).to have_field("ssn", with: "111-22-3333")
    end

    it "ignores non-numeric characters", js: true do
      fill_in "ssn", with: "1a2s3d4"

      expect(page).to have_field("ssn", with: "123-4")
    end

    it "can handle backspace", js: true do
      fill_in "ssn", with: "1112233"
      find("#ssn").send_keys :backspace, :backspace

      expect(page).to have_field("ssn", with: "111-22")

      find("#ssn").send_keys "4", "5", :left, :left, :left, :left, "6"

      expect(page).to have_field("ssn", with: "111-26-245")
    end
  end

  describe "Phone input fields" do
    it "can auto-format a phone number", js: true do
      fill_in "phone", with: "1112223333"

      expect(page).to have_field("phone", with: "(111) 222-3333")
    end

    it "ignores non-numeric characters", js: true do
      fill_in "phone", with: "1a2s3d4"

      expect(page).to have_field("phone", with: "(123) 4")
    end

    it "can handle backspace", js: true do
      fill_in "phone", with: "11122233"
      find("#phone").send_keys :backspace, :backspace

      expect(page).to have_field("phone", with: "(111) 222")

      find("#phone").send_keys "4", "5", :left, :left, :left, :left, "6"

      expect(page).to have_field("phone", with: "(111) 226-245")
    end
  end
end
