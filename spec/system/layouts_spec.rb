require 'spec_helper'

describe 'Layouts' do
  it 'can load the layout index' do
    visit '/cfa/styleguide'
    click_on 'Layouts'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Layouts')
  end

  it 'can load the center-aligned layout page' do
    visit '/cfa/styleguide/layouts'
    click_on 'Center-aligned form card'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Center aligned form card')
  end
end