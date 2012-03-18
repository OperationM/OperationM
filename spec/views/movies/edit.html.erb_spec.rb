require 'spec_helper'

describe "movies/edit.html.erb" do
  before(:each) do
    @movie = assign(:movie, stub_model(Movie))
  end

  it "renders the edit movie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => movies_path(@movie), :method => "post" do
    end
  end
end
