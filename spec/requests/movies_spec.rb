require 'spec_helper'

describe "Movies" do
  describe "GET /movies" do
    it "works! (now write some real specs)" do
      get movies_path
      response.status.should be(302)
    end
  end
end
