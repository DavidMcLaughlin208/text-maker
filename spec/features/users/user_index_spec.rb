include Warden::Test::Helpers
Warden.test_mode!

feature 'User index page', :devise do

  after(:each) do
    Warden.test_reset!
  end

  scenario 'user sees own name' do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit users_path
    expect(page).to have_content user.name
  end
end
