require 'spec_helper'

describe 'Layouts' do
  it 'can load the layout index' do
    visit '/cfa/styleguide'
    click_on 'Layouts'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Layouts')
  end

  it 'can load the center-aligned layout page' do
  end
end