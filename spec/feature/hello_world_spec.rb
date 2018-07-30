require 'spec_helper'

feature 'Hello World' do
  scenario 'can access standard cfa css' do
    visit '/assets/cfa_styleguide_main.css'

    expect(page.status_code).to eq 200
  end

  scenario 'can access standard cfa js' do
    visit '/assets/cfa_styleguide_main.js'

    expect(page.status_code).to eq 200
  end
end
