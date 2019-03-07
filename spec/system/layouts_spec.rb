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
    expect(page.title).to include('Center aligned')
  end

  it 'can load the left-aligned layout page' do
    visit '/cfa/styleguide/layouts'
    click_on 'Left-aligned form card'

    expect(page.status_code).to eq 200
    expect(page.title).to include('Left aligned')
  end

  it 'can load the confirmation layout page' do
    visit '/cfa/styleguide/layouts'
    click_on 'Confirmation form card'

    expect(page.status_code).to eq 200
    expect(page.title).to include('Confirmation')
  end

  it 'can load the progress signpost' do
    visit '/cfa/styleguide/layouts'
    click_on 'Progress signpost card'

    expect(page.status_code).to eq 200
    expect(page.title).to include('Progress Signpost')
  end

  it 'can load the review signpost' do
    visit '/cfa/styleguide/layouts'
    click_on 'Review signpost card'

    expect(page.status_code).to eq 200
    expect(page.title).to include('Review Signpost')
  end

  it 'can load the graphic signpost' do
    visit '/cfa/styleguide/layouts'
    click_on 'Graphic signpost card'

    expect(page.status_code).to eq 200
    expect(page.title).to include('Graphic Signpost')
  end
end