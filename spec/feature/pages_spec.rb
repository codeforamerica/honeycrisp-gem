require 'spec_helper'

feature 'Pages' do
  scenario 'the test app root path redirects to /cfa/styleguide' do
    visit '/'

    expect(current_path).to eq '/cfa/styleguide'
  end

  scenario 'can load styleguide' do
    visit '/cfa/styleguide'

    expect(page.status_code).to eq 200
    expect(page).to have_content("CfA Styleguide v#{Cfa::Styleguide::VERSION}")
  end

  scenario 'can load styleguide cbo dashboard' do
    visit '/cfa/styleguide'
    click_on 'CBO Dashboard'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Assister dashboard')
  end

  scenario 'can load styleguide cbo analytics' do
    visit '/cfa/styleguide'
    click_on 'CBO Analytics'

    expect(page.status_code).to eq 200
    expect(page).to have_content('Overall numbers')
  end

  scenario 'can load styleguide current' do
    visit '/cfa/styleguide'
    click_on 'Current'

    expect(page.status_code).to eq 200
    expect(page).to have_content('The legal stuff')
  end

  scenario 'can load styleguide custom docs' do
    visit '/cfa/styleguide'
    click_on 'Custom Docs'

    expect(page.status_code).to eq 200
    expect(page).to have_content('First, we’ll need to figure out what proof you need to submit.')
  end

  scenario 'can use the CfaFormBuilder' do
    visit '/cfa/styleguide'
    click_on 'Form builder'

    expect(page).to have_content('Example input')
    expect(page).to have_content('Example textarea')
    expect(page).to have_content('Example range')
    expect(page).to have_content('Example date select')

    expect(page).to have_content('Example choice 1')
    expect(page).to have_content('Example choice 2')
    expect(page).to have_content('Example radio set (regular)')
    expect(page).to have_content('Example radio set with follow up')
    expect(page).to have_content('Example select')
  end
end
