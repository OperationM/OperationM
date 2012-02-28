require 'spec_helper'

describe "StaticPages" do
	describe "GET /" do
	  it "should have the content 'Home'" do
	    visit '/'
	    page.should have_content('Home')
	    page.should have_content('About')
	    page.should have_content('Help')
	    page.should have_content('Sign in')
	  end
	end

	describe "GET /static_pages/home" do
	  it "should have the content 'Home'" do
	    visit '/static_pages/home'
	    page.should have_content('Home')
	  end
	end

	describe "GET /static_pages/about" do
	  it "should have the content 'About'" do
	    visit '/static_pages/about'
	    page.should have_content('About')
	  end
	end

	describe "GET /static_pages/Help" do
	  it "should have the content 'Help'" do
	    visit '/static_pages/help'
	    page.should have_content('Help')
	  end
	end

end
