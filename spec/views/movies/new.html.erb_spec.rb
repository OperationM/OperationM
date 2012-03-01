require 'spec_helper'

describe "movies/new.html.erb" do
  before(:each) do
    assign(:movie, stub_model(Movie).as_new_record)
  end

  it "renders new movie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => movies_path, :method => "post" do
    end
  end
end
