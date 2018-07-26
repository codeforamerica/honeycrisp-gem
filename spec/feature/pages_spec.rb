require 'spec_helper'

feature 'Pages' do
  scenario 'can load root page' do
    visit root_path

    expect(page.status_code).to eq 200
    expect(page).to have_content('CfA Styleguide')
  end

  scenario 'can load styleguide' do
    visit '/cfa/styleguide'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Atoms')
  end
end
