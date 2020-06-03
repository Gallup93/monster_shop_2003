require 'rails_helper'

RSpec.describe 'Cart item update' do
  describe "When I have items in my cart" do
    before(:each) do
      login_user
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 2)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end
  end

  it "I see a button or link to increment the count of items I want to purchase" do
    visit "/cart"

    within(".cart-#{@tire.id}") do
      click_link "+"
    end

    expect(page).to have_content("You have changed your cart quantity.")
    expect(page).to have_content("2")
  end

  it "cannot add more to the cart than there is inventory for" do
    visit "/cart"

    expect(page).to have_link("Empty Cart")

    within(".cart-#{@tire.id}") do
      click_link "+"
    end

    expect(page).to have_content("You have changed your cart quantity.")
    expect(page).to have_content("2")

    within(".cart-#{@tire.id}") do
      click_link "+"
    end

    expect(page).to have_content("Not enough in inventory")
    expect(page).to have_content("2")
  end

  it "Decreasing Item Quantity from Cart and hit 0 item removed from cart" do
    visit "/cart"

    expect(page).to have_link("Empty Cart")

    within(".cart-#{@tire.id}") do
      click_link "-"
    end

    within(".cart-#{@tire.id}") do
      click_link "-"
    end

    expect(page).to have_content("You have changed your cart quantity.")
    expect(page).to have_content(@paper.name)
    expect(page).to have_content(@pencil.name)
    expect(page).to_not have_content(@tire.name)
  end
end
