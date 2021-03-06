
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Cart'
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/cart'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/login'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/register'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "gives a 404 when accessing /profile, /merchant, or /admin" do

      visit "/"

      visit "/profile"
      expect(current_path).to eq('/error404')
      visit "/merchant"
      expect(current_path).to eq('/error404')
      visit "/admin"
      expect(current_path).to eq('/error404')
    end
  end
  describe "As a Default user" do
    it "I see all links, plus profile and Log out links. I do NOT see login or register links" do
      default_1 = User.create(name: "Hank Hill", address: "801 N Alamo St", city: "Arlen", state: "Texas", zip: "61109", email: "ProPAIN@aol.com", password: "W33dWacker", role: 0)

      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: default_1.email
      fill_in :password, with: default_1.password

      click_on "Login!"

      expect(current_path).to eq('/profile')

      within 'nav' do
        expect(page).to have_content("logged in as: Hank Hill")
        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'
        expect(current_path).to eq('/')
        click_link 'Cart'
        expect(current_path).to eq('/cart')
        click_link 'Profile'
        expect(current_path).to eq('/profile')
        expect(page).to_not have_link 'Login'
        expect(page).to_not have_link 'Register'
        click_link 'Log out'
        expect(current_path).to eq('/')
      end
    end

    it "gives a 404 when accessing /merchant or /admin" do
      default_1 = User.create(name: "Hank Hill", address: "801 N Alamo St", city: "Arlen", state: "Texas", zip: "61109", email: "ProPAIN@aol.com", password: "W33dWacker", role: 0)
      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: default_1.email
      fill_in :password, with: default_1.password

      click_on "Login!"

      expect(current_path).to eq('/profile')

      visit "/merchant"
      expect(current_path).to eq('/error404')
      visit "/admin"
      expect(current_path).to eq('/error404')
    end
  end

  describe "As a Merchant user" do
    it "I see the same links as a Default user, plus link to my merchant dashboard" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      merchant_1 = dog_shop.users.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1)

      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: merchant_1.email
      fill_in :password, with: merchant_1.password

      click_on "Login!"

      expect(current_path).to eq('/merchant')

      within 'nav' do
        expect(page).to_not have_link 'Login'
        expect(page).to_not have_link 'Register'

        expect(page).to have_content("logged in as: Maude Sloggett")

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'
        expect(current_path).to eq('/')
        click_link 'Cart'
        expect(current_path).to eq('/cart')
        click_link 'Profile'
        expect(current_path).to eq('/profile')
        click_link 'Merchant Dashboard'
        expect(current_path).to eq('/merchant')
        click_link 'Log out'
        expect(current_path).to eq('/')
      end
    end
    it "gives a 404 when accessing /admin" do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      merchant_1 = dog_shop.users.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1)
      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: merchant_1.email
      fill_in :password, with: merchant_1.password

      click_on "Login!"

      expect(current_path).to eq('/merchant')

      visit "/admin"

      expect(current_path).to eq('/error404')
    end
  end
  describe "As an Admin user" do
    it "has default links, additional admin links (/admin, /admin/users), no cart link" do
      admin_1 = User.create(name: "Kurt Cobain", address: "666 Lake Washington Bldv", city: "Seattle", state: "Washington", zip: "32786", email: "GrungeIsDead@gmail.com", password: "Forever27", role: 2)
      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: admin_1.email
      fill_in :password, with: admin_1.password

      click_on "Login!"

      expect(current_path).to eq('/admin')

      within 'nav' do
        expect(page).to_not have_link 'Login'
        expect(page).to_not have_link 'Register'
        expect(page).to_not have_link 'Cart'

        expect(page).to have_content("logged in as: Kurt Cobain")

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'
        expect(current_path).to eq('/')
        click_link 'Profile'
        expect(current_path).to eq('/profile')
        click_link 'Admin Dashboard'
        expect(current_path).to eq('/admin')
        click_link 'All Users'
        expect(current_path).to eq('/admin/users')
        click_link 'Log out'
        expect(current_path).to eq('/')
      end
    end

    it "gives a 404 when accessing /merchant or /cart" do
      admin_1 = User.create(name: "Kurt Cobain", address: "666 Lake Washington Bldv", city: "Seattle", state: "Washington", zip: "32786", email: "GrungeIsDead@gmail.com", password: "Forever27", role: 2)
      visit "/"

      within 'nav' do
        click_link "Login"
      end

      expect(current_path).to eq('/login')

      fill_in :email, with: admin_1.email
      fill_in :password, with: admin_1.password

      click_on "Login!"

      expect(current_path).to eq('/admin')

      visit "/cart"

      expect(current_path).to eq('/error404')

      visit "/merchant"

      expect(current_path).to eq('/error404')
    end
  end
end
