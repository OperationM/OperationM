require 'spec_helper'

describe "StaticPages" do
  describe "GET /static_pages/home" do
    it "should have the content 'Moogle'" do
      visit '/static_pages/home'
      page.should have_content('Moogle')
    end
  end
end
