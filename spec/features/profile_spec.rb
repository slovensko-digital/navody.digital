require 'rails_helper'

RSpec.feature "Profile features", type: :feature do
  let(:user) { create(:user, email: 'someone@example.com') }

  scenario 'As a user I can delete my profile' do
    sign_in(user)

    visit profile_path

    click_link 'Zmazať profil'

    expect(page).to have_content('Váš profil bol úspešne zmazaný.')
    expect(page).to have_current_path(root_path)
  end
end
