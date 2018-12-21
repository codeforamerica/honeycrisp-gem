require 'spec_helper'

feature 'Examples' do
  scenario 'can render out a specific example' do
    visit '/cfa/styleguide/examples/molecules/progress_step_bar'

    expect(page.status_code).to eq 200
  end
end
