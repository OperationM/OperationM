require 'spec_helper'

describe "movies/index.html.erb" do
  before(:each) do
    assign(:movies, [
      stub_model(Movie),
      stub_model(Movie)
    ])
  end

  it "renders a list of movies" do
    render
  end
end
