def sign_in(user)
  OmniAuth.config.test_mode = false
  visit new_session_path

  within 'form#login-email' do
    fill_in :email, with: user.email
  end

  click_on 'Prihlásiť sa e-mailom'

  visit link_in_last_email
  expect(page).to have_content('Prihlásenie úspešné.')
end
